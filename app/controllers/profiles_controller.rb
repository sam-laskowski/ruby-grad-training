class ProfilesController < ApplicationController

  def show
    @user = User.find(session[:current_user_id])
  end
end
