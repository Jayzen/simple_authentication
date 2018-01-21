class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, 
                                   :authorize, :unauthorize,
                                   :avatar_new, :avatar_create, :avatar_update]
  before_action :logged_in_user, only: [:edit, :update, :destroy, :show,
                                        :avatar_create, :avatar_update, :avatar_new]
  before_action :correct_user, only: [:edit, :update,
                                   :avatar_create, :avatar_update, :avatar_new]
  before_action :admin_user, only: :destroy
  before_action :superadmin_user, only: [:authorize, :unauthorize]

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
    render action: :new
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "用户更新成功!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def avatar_new 
    
  end

  def avatar_create
    
  end

  def avatar_update

  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "用户已经被删除!"
    redirect_to users_path
  end

  def authorize
    @user.toggle!(:admin)
    
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def forbidden
    @user = User.find(params[:user_id])
    @user.toggle!(:forbidden)

    respond_to do |format|
      format.html { redirect_to users_path }
      format.js
    end
  end

  def unforbidden
    @user = User.find(params[:user_id])
    @user.toggle!(:forbidden)

    respond_to do |format|
      format.html { redirect_to users_path }
      format.js
    end
  end

  def unauthorize
    @user.toggle!(:admin)
    
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end 
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, 
                                   :email, 
                                   :password, 
                                   :password_confirmation,
                                   :portrait
                                  )
    end
end
