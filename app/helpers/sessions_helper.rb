module SessionsHelper

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end

  def sign_out
    session.delete(:user_id)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def signed_out_user
    if signed_in?
      redirect_to root_path
    end
  end
end