class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save

      session[:current_user_id] = @user.id
      cookies.signed[:cable_user_id] = { value: @user.id, httponly: true }
      redirect_to edit_onboarding_path(@user), notice: "Registered Succesfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password)
    end
end
