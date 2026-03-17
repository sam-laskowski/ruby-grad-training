class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(username: params[:user][:username])
    if @user
      if @user.authenticate(params[:user][:password])
        reset_session
        session[:current_user_id] = @user.id
        redirect_to root_url, notice: "Signed in."
      else
        flash.now[:alert] = "Incorrect username or password."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Incorrect username or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
