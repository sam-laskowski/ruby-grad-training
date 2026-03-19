class ConfirmedEventsController < ApplicationController
  before_action :require_login, only: [:show]

  def show
    @confirmed_events = GamePost.confirmed_for_user(current_user)
  end

end
