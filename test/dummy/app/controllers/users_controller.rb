class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "用户注册成功!"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "用户更新成功!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.order("created_at desc").page(params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "用户已经被删除!"
    redirect_to users_path
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
