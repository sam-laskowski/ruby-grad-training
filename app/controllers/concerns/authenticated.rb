module Authenticated
  extend ActiveSupport::Concern

  included do
    before_action :current_user
    helper_method :current_user
    helper_method :user_signed_in?
  end

  def current_user
    if session[:current_user_id]
      current_user ||= User.find_by(id: session[:current_user_id])
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def require_login
    unless user_signed_in?
      flash[:alert] = "You must be signed in to access this section"
      redirect_to root_path # Or your login_path
    end
  end

end