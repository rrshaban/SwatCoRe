class UsersController < ApplicationController
  before_action :admin_user, only: [:index]

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
  end

  def index
    @users = User.all
  end
end
