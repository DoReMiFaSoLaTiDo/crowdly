class Api::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  before_action :authenticate_with_token!, only: [:update, :destroy]
  before_filter :set_user, only: [:show, :update, :destroy ]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(approved_params)

    if @user.save
      render json: @user, status: 201
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def update
    user = current_user
    if user.update(approved_params)
      render json: user, status: 201
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    head 204
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def approved_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation)
    end

    def render_404
      render json: { error: "Record Not Found", status: 404 }
    end
end
