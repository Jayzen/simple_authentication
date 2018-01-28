class PortraitsController < ApplicationController
  before_action :get_user, only: [:edit, :create, :update]
  
  def new
  end

  def create
    if @user.update_attributes(user_params)
      if params[:portrait][:avatar].present?
        render :crop
      else
        redirect_to portrait_path(current_user.id)
        flash[:success] = "头像上传成功!"
      end
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      if params[:portrait][:avatar].present?
        render :crop
      else
        redirect_to portrait_path(current_user.id)
        flash[:success] = "头像裁剪成功!"
      end
    else
      render :new
    end
  end
 
  def show
  end

  private
    def get_user
      @user = User.find(params[:user_id])
    end

    def user_params
      params.require(:portrait).permit(:avatar, :crop_x, :crop_y, :crop_w, :crop_h)
    end
end
