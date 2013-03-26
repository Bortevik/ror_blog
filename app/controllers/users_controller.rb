class UsersController < ApplicationController

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_activation_link
      flash[:success] = 'Activation link was sent to your email'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def activate
    user = User.find_by_secret_token!(params[:id])
    if user.update_attribute(:activated, true)
      flash[:success] = 'Your account was activated!'
    else
      flash[:error] = 'Activation failed'
    end
    redirect_to root_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile was updated!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User was deleted!'
    redirect_to users_url
  end
end
