class BroadcastNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id:, message:, link: nil, metadata: {})
    user = User.find_by(id: user_id)
    return if user.blank?

    notification = user.notifications.create!(message: message, link: link)

    ActionCable.server.broadcast(
      "notifications:#{user.id}",
      {
        id: notification.id,
        message: notification.message,
        link: notification.link,
        created_at: notification.created_at.iso8601
      }.merge(metadata)
    )
  end
end
