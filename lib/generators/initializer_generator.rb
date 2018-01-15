class InitializerGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)


  desc "remove initializer file"
  def remove_initializer_file
    remove_file "app/assets/stylesheets/application.css"
    remove_file "app/views/layouts/application.html.erb"
  end

  desc "copy initializer file"
  def copy_initializer_file
    copy_file "assets/application.scss", "app/assets/stylesheets/application.scss"
    copy_file "views/layouts/application.html.erb", "app/views/layouts/application.html.erb"
    copy_file "controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
    copy_file "controllers/users_controller.rb", "app/controllers/users_controller.rb"
    copy_file "migrate/20180113142458_create_users.rb", "db/migrate/20180113142458_create_users.rb"
    copy_file "models/user.rb", "app/models/user.rb"
    copy_file "views/sessions/new.html.erb", "app/views/sessions/new.html.erb"
    copy_file "views/shared/_error_messages.html.erb", "app/views/shared/_error_messages.html.erb"
    copy_file "views/shared/_judge_login.html.erb", "app/views/shared/_judge_login.html.erb"
    copy_file "views/users/new.html.erb", "app/views/users/new.html.erb"
    copy_file "views/users/show.html.erb", "app/views/users/show.html.erb"
  end

  desc "modify initializer file"
  def modify_initializer_file
    inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-'RUBY'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
RUBY
    end
 
    inject_into_file 'app/assets/javascripts/application.js', after: "//= require turbolinks\n" do <<-'RUBY'
//= require jquery3
//= require popper
//= require bootstrap
RUBY
    end

    inject_into_file 'app/controllers/application_controller.rb', after: "protect_from_forgery with: :exception\n" do <<-'RUBY'
  include SimpleAuthentication::Authenticate
  authenticate
RUBY
    end

    inject_into_file 'app/helpers/application_helper.rb', after: "module ApplicationHelper\n" do <<-'RUBY'
  include SimpleAuthentication::Authenticate::LocalInstanceMethods
RUBY
    end

    inject_into_file 'Gemfile', after: "source 'https://rubygems.org'\n" do <<-'RUBY'
gem 'bootstrap', '~> 4.0.0.beta3'
gem 'font-awesome-rails'
gem 'bcrypt'
gem 'jquery-rails'
RUBY
    end
  end
end
