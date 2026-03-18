class ProfilesController < ApplicationController
  before_action :require_login, only: [:show]

  def show
    if user_signed_in?
      @user = User.find(session[:current_user_id])
    end
  end
end
