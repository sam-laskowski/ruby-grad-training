class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :game_post

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  after_create_commit :notify_game_owner_of_request, if: :pending_request_for_other_user?
  after_commit :update_game_post_status, if -> { saved_change_to_status? && accepted? }
  after_update_commit :notify_requester_of_acceptance, if: :accepted_status_change?

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

  def pending_request_for_other_user?
    pending? && user_id != game_post.user_owner_id
  end

  def accepted_status_change?
    saved_change_to_status? && accepted? && user_id != game_post.user_owner_id
  end

  def notify_game_owner_of_request
    owner_pending_requests_count = Enrollment.pending
                                            .joins(:game_post)
                                            .where(game_posts: { user_owner_id: game_post.user_owner_id })
                                            .where.not(user_id: game_post.user_owner_id)
                                            .count

    BroadcastNotificationJob.perform_later(
      user_id: game_post.user_owner_id,
      message: "#{user.username} requested to join #{game_post.name}.",
      link: "/game_posts/#{game_post.id}",
      metadata: {
        notification_type: "request_received",
        pending_requests_count: owner_pending_requests_count
      }
    )
  end

  def notify_requester_of_acceptance
    BroadcastNotificationJob.perform_later(
      user_id: user_id,
      message: "Your request to join #{game_post.name} was accepted.",
      link: "/game_posts/#{game_post.id}"
    )
  end
  end
end
