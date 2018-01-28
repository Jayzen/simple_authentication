class PortraitsController < ApplicationController
  before_action :logged_in_user

  def new
  end

  def create
    @user = User.find(params[:user_id])
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
    @user = User.find(params[:user_id])
    if @user.update_attributes(user_params)
      if params[:portrait][:avatar].present?
        render :crop
      else
        redirect_to user_path(current_user)
        flash[:success] = "头像裁剪成功!"
      end
    else
      render :new
    end
  end
 

  private
    def user_params
      params.require(:portrait).permit(:avatar, :crop_x, :crop_y, :crop_w, :crop_h)
    end
end
