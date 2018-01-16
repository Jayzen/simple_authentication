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
    copy_file "controllers/welcomes_controller.rb", "app/controllers/welcomes_controller.rb"
    copy_file "migrate/20180113142458_create_users.rb", "db/migrate/20180113142458_create_users.rb"
    copy_file "models/user.rb", "app/models/user.rb"
    copy_file "views/sessions/new.html.erb", "app/views/sessions/new.html.erb"
    copy_file "views/shared/_errors.html.erb", "app/views/shared/_errors.html.erb"
    copy_file "views/shared/_navbar.html.erb", "app/views/shared/_navbar.html.erb"
    copy_file "views/shared/_flash.html.erb", "app/views/shared/_flash.html.erb"
    copy_file "views/users/new.html.erb", "app/views/users/new.html.erb"
    copy_file "views/users/show.html.erb", "app/views/users/show.html.erb"
    copy_file "views/users/edit.html.erb", "app/views/users/edit.html.erb"
    copy_file "views/users/index.html.erb", "app/views/users/index.html.erb"
    copy_file "views/welcomes/index.html.erb", "app/views/welcomes/index.html.erb"
    copy_file "locales/zh.yml", "config/locales/zh.yml"
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
  root 'welcomes#index'
RUBY
    end
 
    inject_into_file 'app/assets/javascripts/application.js', after: "//= require turbolinks\n" do <<-'RUBY'
//= require jquery3
//= require popper
//= require bootstrap
RUBY
    end

    inject_into_file 'app/controllers/application_controller.rb', after: "protect_from_forgery with: :exception\n" do <<-'RUBY'
  before_action :set_locale
  include SimpleAuthentication::Authenticate
  authenticate
  
  private
    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale 
    end
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
gem 'kaminari'
RUBY
    end

    inject_into_file 'config/application.rb', after: "config.load_defaults 5.1\n" do <<-'RUBY'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :zh
    config.encoding = 'utf-8'
    config.generators do |generator|
      generator.assets false
      generator.test_framework false
      generator.skip_routes true
    end
RUBY
    end
  end
end
