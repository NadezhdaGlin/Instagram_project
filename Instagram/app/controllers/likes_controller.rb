class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.create(user: current_user, post: @post)
  end

  def destroy 
    @post = Post.find(params[:post_id])
    @like = @post.likes.find(params[:id])
    @like.destroy
  end

end
