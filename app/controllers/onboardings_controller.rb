class OnboardingsController < ApplicationController
  before_action :set_user

  def edit
    @user = User.find(session[:current_user_id])
  end

  def update
    @user = User.find(session[:current_user_id])
    if @user.update(onboarding_params)
      redirect_to game_posts_path, notice: "Welcome aboard!"
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def onboarding_params
    params.require(:user).permit(:name, :bio, :photo)
  end
end
