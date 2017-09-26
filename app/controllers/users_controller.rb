class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :load_user, only: %i(update destroy)

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t "errorss"
    redirect_to users_path
  end

  def index
    @users = User.sort_by_name.paginate(page: params[:page], per_page: Settings.per_page.config)
  end

  def show
    load_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "messeger"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    load_user
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "update_profile"
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "delete_use"
    else
      flash[:danger] =  t "eror_destroy"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "ple_login"
    redirect_to login_url
  end

  def correct_user
    load_user
    redirect_to(root_url) unless current_user.admin?
  end
end
