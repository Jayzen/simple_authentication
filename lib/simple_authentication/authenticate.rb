module SimpleAuthentication
  module Authenticate
    extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      def authenticate
        include SimpleAuthentication::Authenticate::LocalInstanceMethods
      end
    end
 
    module LocalInstanceMethods
        def log_in(user)
          session[:user_id] = user.id
        end

        def current_user
          @current_user ||= User.find_by(id: session[:user_id])
        end

        def logged_in?
          !current_user.nil?
        end

        def log_out
          session.delete(:user_id)
          @current_user = nil
        end

        def logged_in_user
          unless logged_in?
            store_location
            flash[:danger] = "用户需要进行登录!"
            redirect_to login_url
          end
        end

        def correct_user
          @user = User.find(params[:id])
          redirect_to(root_url) unless current_user?(@user)
        end

        def current_user?(user)
          user == current_user
        end

        def redirect_back_or(default)
          redirect_to(session[:forwarding_url] || default)
          session.delete(:forwarding_url)
        end

        def store_location
          session[:forwarding_url] = request.original_url if request.get?
        end

        def admin_user
          redirect_to(root_url) unless current_user.admin?
        end
    end
  end
end

