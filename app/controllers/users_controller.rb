class UsersController < ApplicationController
  before_action :signed_in_user,      only: [:index, :edit, :update, :destroy]
  before_action :correct_user,        only: [:edit, :update]
  before_action :admin_user,          only: :destroy
  before_action :create_user,         only: [:new, :create]
  before_action :delete_only_others,  only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    def correct_user
      @user = find_param_user
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def create_user
      redirect_to(root_url) if signed_in?
    end

    def delete_only_others
      redirect_to(root_url) if current_user?(find_param_user)
    end

    def find_param_user
      User.find(params[:id])
    end
end
