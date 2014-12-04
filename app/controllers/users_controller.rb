class UsersController < ApplicationController
  before_action :set_user, only: [:show, :followees, :followers]
  before_action :create_post, only:[ :show]

  def index
    @users = User.except(current_user)
  end

  def show  
  end
 
  def timeline
    @tweets = current_user.timeline
  end

  def followees
    @users = @user.followees
    render action: 'index'
  end

  def followers
    @users = @user.followers
    render action: 'index'
  end

  protected
    def create_post
      @post = Post.new
    end

    def set_user
      @user = User.find_by(username: params[:id])
      if(@user.nil?)
        flash[:alert] = "User by this name does not exist"
        redirect_to_back_or_default_url
      end
    end
end