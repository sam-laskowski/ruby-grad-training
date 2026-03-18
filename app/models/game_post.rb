class GamePost < ApplicationRecord

  attr_accessor :duration
  belongs_to :user_owner, class_name: "User"
  has_many :enrollments, dependent: :destroy
  has_many :subscribers, through: :enrollments, source: :user

  has_many_attached :images

  has_many :accepted_subscribers, -> { where(enrollments: { status: :accepted }) }, 
           through: :enrollments, source: :user

  enum status: { open:0, full:1, cancelled:2, completed:3 }

  validate :owner_must_not_be_enrolled, on: :create

  before_save :calculate_end_time

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
end
