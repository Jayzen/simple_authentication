class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "用户登录成功!"
      redirect_back_or user
    else
      flash.now[:danger] = '邮箱或者密码错误!'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end
end
