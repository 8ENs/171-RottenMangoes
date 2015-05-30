class Admin::UsersController < ApplicationController

  def index
    if admin?
      @users = User.order(admin: :desc, lastname: :asc, firstname: :asc).page(params[:page]).per(10)
    else
      access_denied
    end
  end

  def new
    if admin?
      @user = User.new
      @url = admin_users_path(@user)
    else
      access_denied
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "#{@user.full_name} was created successfully!"
    else
      render :new
    end
  end

  def show
    if admin?
      @user = User.find(params[:id])
    else
      access_denied
    end
  end

  def edit
    @user = User.find(params[:id])
    @url = admin_user_path(@user)
  end

  def update
    @user = User.find(params[:id])
    @url = admin_user_path(@user)

    if @user.update_attributes(user_params)
      redirect_to admin_users_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    # clear session if deleting self (this has been tested but should not be used since 'delete' hidden on self)
    session[:user_id] = nil if current_user == @user
    
    # send notification email
    UserMailer.delete_user_email(@user).deliver_now
    
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted..."
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end

  def access_denied
    redirect_to movies_path, notice: "Only admins can access that page!"
  end

end
