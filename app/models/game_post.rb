class GamePost < ApplicationRecord
  belongs_to :user_owner, class_name: "User"
  has_many :enrollments
  has_many :subscribers, through: :enrollments, source: :user

  has_many :accepted_subscribers, -> { where(enrollments: { status: :accepted }) }, 
           through: :enrollments, source: :user

  enum status: { open:0, full:1, cancelled:2, completed:3 }
end
