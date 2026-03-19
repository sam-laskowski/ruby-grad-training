class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :game_post

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  after_commit :update_game_post_status, if -> { saved_change_to_status? && accepted? }

  private

  def user_must_be_free_to_enroll
    if user.owned_games.exists?
      errors.add(:base, "You cannot join a game while you have an active listing of your own.")
    end

    if user.enrollments.where(status: :pending).exists?
      errors.add(:base, "You already have a pending request elsewhere.")
    end
  end
  
  def update_game_post_status
    game_post.check_if_full!
  end
end
end
