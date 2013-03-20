class SessionsController < ApplicationController
  before_filter :signed_out_user, only: [:new, :create]

  def new
    session[:return_to] = request.referer
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      flash[:success] = "Welcome #{user.name}!"
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
