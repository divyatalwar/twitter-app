class PostsController < ApplicationController

  before_action :set_user_post, only: [:retweet]
  skip_before_action :authorize, only: [:index]

  def index
    @tweets = Tweet.order(created_at: :desc).eager_loading_associations
  end

  def edit
  end

  def create
    @post = current_user.posts.create(post_params)
    if(@post.persisted?)
      flash[:notice] = "Post was successfully created"
      redirect_to user_path(current_user.username)
    else
      flash[:alert] = "Post could not be saved because "  + @post.errors.full_messages.join(" ,")
      render action: 'edit'
    end
    
  end

  def hash_tags
    @tweets = Tweet.by_hash_tag(params[:hash_tag])
    render action: 'index'
  end

  def retweet
    @tweet.retweet(current_user)
    redirect_to_back_or_default_url
  end

  private
    def set_user_post
      @tweet = Tweet.find_by(id: params[:id])
      redirect_to_back_or_default_url if @tweet.nil?
    end

    def post_params
      params.require(:post).permit(:content)
    end
end
