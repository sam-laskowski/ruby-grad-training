class EnrollmentsController < ApplicationController

  before_action :set_game_post

  def create
    @enrollment = current_user.enrollments.find_or_create_by(game_post: @game_post)
    # @enrollment.status = :pending
    if @enrollment.save
      redirect_to game_posts_path, notice: "Request sent, waiting for approval"
    end
  end

  def destroy
    @enrollment = current_user.enrollments.find(params[:id])
    @enrollment.destroy

    redirect_to game_posts_path, notice: "You've unrequested"
  end

  def update
    @enrollment = Enrollment.find(params[:id])

    if current_user == @enrollment.game_post.user_owner
      if @enrollment.update(status: params[:status])
        redirect_to @enrollment.game_post, notice: "User accepted"
      else
        redirect_to game_post_path(@enrollment.game_post), alert: "Something went wrong."
      end
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end

  private
    def set_game_post
      @game_post = GamePost.find(params[:game_post_id])
    end
end
