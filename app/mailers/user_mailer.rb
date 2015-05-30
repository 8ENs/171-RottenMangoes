class UserMailer < ApplicationMailer

  def delete_user_email(user)
    @user = user
    @url = "http://localhost:3000/users/new"
    mail(to: @user.email, subject: 'Your Rotten Mango Account has been Removed')
  end

end
