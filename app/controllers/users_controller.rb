class UsersController < ApplicationController
  before_action :admin_user, only: [:index]
  before_action :set_user, only: [:show, :destroy]

  def karma
    @users = User.all.sort_by {|u| u.karma }.last(20).reverse
  end

  def show
    @reviews = @user.reviews.where(hidden: false).order(created_at: :desc)
  end

  def index
    @users = User.all
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
