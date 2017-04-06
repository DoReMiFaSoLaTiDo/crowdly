class Api::PostsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  before_action :authenticate_with_token!, only: [:create]
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :set_user, only: [:index, :show, :index]

  def show
    render json: @post
  end

  def index
    render json: @user.posts
  end

  def create
    post = current_user.posts.build(approved_params)
    if post.save
      render json: post, status: 201
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def update
    raise ActiveRecord::RecordNotFound unless current_user.posts.include? @post

    if @post.update(approved_params)
      render json: @post, status: 200
    else
      render json: { errors: @post.errors }, status: 422
    end
  end

  def destroy
    raise ActiveRecord::RecordNotFound unless current_user.posts.include? @post
    post = current_user.posts.find(params[:id])
    post.destroy
    head 204
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def approved_params
      params.require(:post).permit(:id, :title, :body, :user_id)
    end

    def render_404
      render json: { error: "Record Not Found", status: 404 }
    end
end
