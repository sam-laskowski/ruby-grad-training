class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :game_post

  enum status: { pending: 0, accepted: 1, rejected: 2 }
  private

  def user_must_be_free_to_enroll
    # Check if they own any game posts
    if user.owned_games.exists?
      errors.add(:base, "You cannot join a game while you have an active listing of your own.")
    end

    # Check if they have any other pending enrollments
    if user.enrollments.where(status: :pending).exists?
      errors.add(:base, "You already have a pending request elsewhere.")
    end
  end
end
