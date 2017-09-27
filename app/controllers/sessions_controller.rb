class SessionsController < ApplicationController
  def new; end

  def remember_params user
    params[:session][:remember_me] == Settings.sessions.check ? remember(user) : forget(user)
  end

  def message_account user
    if user.activated?
      log_in user
      remember_params user
      redirect_back_or user
    else
      message = t "account_not"
      message += t "for_check"
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      message_account user
    else
      flash.now[:danger] = t "session_error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
