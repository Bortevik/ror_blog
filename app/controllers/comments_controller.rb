class CommentsController < ApplicationController

  load_and_authorize_resource only: :destroy

  def create
    redirect_without_post
    comment = @post.comments.build(params[:comment])
    comment.user_id = current_user.try(:id) # nil as Guest
    comment.save
    redirect_to post_url(@post)
  end

  def destroy
    @comment.update_column(:body, '#deleted#')
    redirect_to "#{post_url(@comment.post)}/#comment_#{@comment.id}"
  end

  private

    def redirect_without_post
     @post = Post.find(params[:post_id])
     redirect_to root_url if @post.nil?
    end
end
