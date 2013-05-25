class TagsController < ApplicationController

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.includes(:tags).page(params[:page]).per_page(10)
    render 'posts/index'
  end
end
