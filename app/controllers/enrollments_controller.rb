class EnrollmentsController < ApplicationController

  before_action :set_game_post

  def create
    @enrollment = current_user.enrollments.find_or_create_by(game_post: @game_post)
    if @enrollment.save
      redirect_to game_posts_path, notice: "You've subscribed to this game listing"
    end
  end

  def destroy
    @enrollment = current_user.enrollments.find(params[:id])
    @enrollment.destroy

    redirect_to game_posts_path, notice: "You've unsubscribed"
  end

  private
    def set_game_post
      @game_post = GamePost.find(params[:game_post_id])
    end
end
