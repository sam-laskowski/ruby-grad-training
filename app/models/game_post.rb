class GamePost < ApplicationRecord
  belongs_to :user_owner, class_name: "User"
  has_many :enrollments, dependent: :destroy
  has_many :subscribers, through: :enrollments, source: :user

  has_many :accepted_subscribers, -> { where(enrollments: { status: :accepted }) }, 
           through: :enrollments, source: :user

  enum status: { open:0, full:1, cancelled:2, completed:3 }

  validate :owner_must_not_be_enrolled, on: :create

  private

  def owner_must_not_be_enrolled
    if user_owner.enrollments.exists?
      errors.add(:base, "You cannot start a new listing while you are enrolled in another game.")
    end
  end
end
