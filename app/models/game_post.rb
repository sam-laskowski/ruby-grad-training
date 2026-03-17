class GamePost < ApplicationRecord
  belongs_to :user_owner, class_name: "User"
  has_many :enrollments
  has_many :enrolled_users, through: :enrollments

  enum status: { open:0, full:1, cancelled:2, completed:3 }
end
