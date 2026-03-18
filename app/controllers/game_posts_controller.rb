class GamePostsController < ApplicationController

  before_action :require_login, only: [:new, :create]

  def index
    @game_posts = GamePost.includes(:user_owner, :subscribers).all
  end

  def show
    @game_post = GamePost.find(params[:id])

    if current_user == @game_post.user_owner
      @pending_enrollments = @game_post.enrollments.pending
    end
  end

  def new
    @game_post = current_user.game_posts.build
  end

  def create
    @game_post = GamePost.new(game_post_params)
    @game_post.user_owner = current_user
    @game_post.status = 0
    if @game_post.save
      redirect_to game_posts_path, notice: "Game post created"
    else
      puts @game_post.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # GamePost.find(params[:id]).destroy
    # redirect_to game_posts_url

    @game_post = current_user.owned_games.find(params[:id])
  
    @game_post.destroy
    redirect_to game_posts_url, notice: "Post deleted."
    rescue ActiveRecord::RecordNotFound
    redirect_to game_posts_url, alert: "You can't delete what you don't own!"
  end



  private
    def game_post_params
      params.require(:game_post).permit(:name, :location, :time_start, :time_end, :total_players, :description, :details, :duration, images: [])
    end

    def require_login
      unless user_signed_in?
        redirect_to login_path, alert: "You must be logged in to create a post."
      end
    end
end