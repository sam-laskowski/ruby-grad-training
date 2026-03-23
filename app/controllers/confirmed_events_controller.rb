class ConfirmedEventsController < ApplicationController
  before_action :require_login, only: [ :show ]

  def show
    @game_post = GamePost.confirmed_for_user(current_user).last
  end
end
