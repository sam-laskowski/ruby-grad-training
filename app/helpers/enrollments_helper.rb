module EnrollmentsHelper
  def subscription_button_for(game_post, options = {})
    return link_to("Log in to request", login_path) if current_user.nil?

    enrollment = current_user.enrollments.find_by(game_post: game_post)
    if enrollment
      button_to "Unrequest", game_post_enrollment_path(game_post, enrollment),
      method: :delete
    else
      button_to "Request", game_post_enrollments_path(game_post),
      { method: :post }.merge(options)
    end
  end
end
