class PostsController < ApplicationController
  load_and_authorize_resource

  def index
    @posts = Post.paginate(page: params[:page], per_page: 10)
  end

  def show
    @comment = @post.comments.build
    @comments = @post.comments.includes(:user)
  end

  def new
  end

  def create
    if @post.save
      flash[:success] = 'New post created!'
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(params[:post])
      flash[:success] = 'Post updated!'
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'Post was deleted!'
    redirect_to root_url
  end
end
