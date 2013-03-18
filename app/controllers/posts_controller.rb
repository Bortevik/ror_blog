class PostsController < ApplicationController

  def index
    @posts = Post.paginate(page: params[:page], per_page: 10)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new()
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      flash[:success] = 'New post created!'
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:success] = 'Post updated!'
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = 'Post was deleted!'
    redirect_to root_url
  end
end
