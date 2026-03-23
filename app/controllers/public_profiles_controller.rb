class PublicProfilesController < ApplicationController
  before_action :require_login, only: [ :show ]

  def show
    if user_signed_in?
      @user = User.find(params[:id])
    end
  end
end
