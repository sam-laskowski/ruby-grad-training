class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :game_post

  enum status: { pending: 0, accepted: 1, rejected: 2 }
end
