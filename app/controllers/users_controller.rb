class UsersController < ApplicationController
  load_and_authorize_resource except: :activate

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  end

  def new
  end

  def create
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
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile was updated!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'Your account was deleted'
    redirect_to root_url
  end
end
