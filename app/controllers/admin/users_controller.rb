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

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "#{@user.full_name} was created successfully!"
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_users_path(@user)
    else
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted..."
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end

end
