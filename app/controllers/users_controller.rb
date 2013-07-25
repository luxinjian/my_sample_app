class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Sign up success!"
      redirect_back_or @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Update success!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 13)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 13)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "user destroyed."
    redirect_to users_path
  end

  private

  def correct_user
    user = User.find(params[:id])
    unless current_user?(user)
      redirect_to root_path
    end
  end

  def admin_user
    user = User.find(params[:id])
    redirect_to root_path unless (!user.admin? && current_user.admin?)
  end
end
