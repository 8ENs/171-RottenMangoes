class Admin::UsersController < ApplicationController
  
  def index
    if admin?
      @users = User.all
    else
      redirect_to movies_path, notice: "Only admins can access that page!"
    end
  end
  
end
