class PasswordResetsController < ApplicationController
  before_filter :expired_secret_token, only: [:edit, :update]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      flash[:info] = "Email sent with password reset instructions
                      to #{params[:email]}."
    else
      flash[:error] = "Not found user with email #{params[:email]}."
    end
    redirect_to root_path
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Password has been updated.'
      redirect_to root_url
    else
      render :edit
    end
  end

  private

    def expired_secret_token
      @user = User.find_by_secret_token!(params[:id])
      if @user.secret_token_sent_at < 2.hours.ago
        flash[:error] = 'Password reset has expired.'
        redirect_to new_password_reset_url
      end
    end
end
