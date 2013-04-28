module SessionsHelper

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    if params[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
    self.current_user = user
  end

  def sign_out
    cookies.delete(:auth_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
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

  def not_activated_user
    @user = User.find_by_email(params[:email].downcase)
    return if @user.nil?
    unless @user.activated
      flash[:error] = 'Your account not yet activated. Check your email box
                       for email with activation link'
      @user.send_activation_link
      redirect_to root_url
    end
  end
end
