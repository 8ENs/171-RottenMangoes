class Admin::UsersController < ApplicationController

  def index
    if admin?
      @users = User.order(admin: :desc, lastname: :asc, firstname: :asc).page(params[:page]).per(10)
    else
      redirect_to movies_path, notice: "Only admins can access that page!"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted..."
  end

end
