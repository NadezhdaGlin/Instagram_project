# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @post = Post.find(params[:format])
    @like = @post.likes.create(user: current_user, post: @post)
    redirect_to @post
  end

  def destroy
    @post = Post.find(params[:id])
    @like = Like.where(user: current_user, post: @post)
    @like.destroy_by(id: @like.ids)
    redirect_to @post
  end
end
