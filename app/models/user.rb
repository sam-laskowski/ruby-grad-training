class User < ApplicationRecord
  has_secure_password

  has_one_attached :photo

  validates :username, presence: true, uniqueness: true

  has_many :owned_games, class_name: "GamePost", foreign_key: "user_owner_id"
  has_many :enrollments
  has_many :game_posts, through: :enrollments
end