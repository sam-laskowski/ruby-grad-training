class GamePost < ApplicationRecord
  attr_accessor :duration
  belongs_to :user_owner, class_name: "User"
  has_many :enrollments, dependent: :destroy
  has_many :subscribers, through: :enrollments, source: :user

  has_many_attached :images

  has_many :accepted_subscribers, -> { where(enrollments: { status: :accepted }) },
           through: :enrollments, source: :user

  enum status: { open: 0, full: 1, confirmed: 2, cancelled: 3, completed: 4 }

  validate :owner_must_not_be_enrolled, on: :create

  after_create :enroll_owner

  before_save :calculate_end_time
  after_update_commit :notify_accepted_players_of_confirmation, if: :confirmed_status_change?

  scope :confirmed_for_user, ->(user) {
    joins(:enrollments)
      .where(status: :confirmed)
      .where(enrollments: { user_id: user.id, status: :accepted })
  }

  scope :not_confirmed, -> { where.not(status: :confirmed) }

  has_one_attached :cover_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 200, 100 ]
  end

  def check_if_full!
    return unless open? && total_players.present?

    if accepted_subscribers.count >= total_players
      full!
    end
  end

  private

  def owner_must_not_be_enrolled
    if user_owner.enrollments.exists?
      errors.add(:base, "You cannot start a new listing while you are enrolled in another game.")
    end
  end

  def calculate_end_time
    if time_start.present? && duration.present?
      self.time_end = time_start + duration.to_i.hours
    end
  end

  def enroll_owner
    enrollments.create(user: user_owner, status: :accepted)
  end

  def confirmed_status_change?
    saved_change_to_status? && confirmed?
  end

  def notify_accepted_players_of_confirmation
    accepted_subscribers.distinct.find_each do |accepted_user|
      BroadcastNotificationJob.perform_later(
        user_id: accepted_user.id,
        message: "#{name} has been confirmed.",
        link: "/game_posts/#{id}",
        metadata: {
          notification_type: "event_confirmed",
          game_post_id: id
        }
      )
    end
  end
end
