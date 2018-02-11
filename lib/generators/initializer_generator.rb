class InitializerGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)


  desc "remove initializer file"
  def remove_initializer_file
    remove_file "app/assets/stylesheets/application.css"
    remove_file "app/views/layouts/application.html.erb"
    remove_file "app/views/layouts/mailer.html.erb"
  end

  desc "copy initializer file"
  def copy_initializer_file
    copy_file "assets/application.scss", "app/assets/stylesheets/application.scss"
    copy_file "assets/avatar.coffee", "app/assets/javascripts/avatar.coffee"
    copy_file "assets/foundation_emails.scss", "vendor/assets/stylesheets/foundation_emails.scss"
    copy_file "assets/male.jpeg", "app/assets/images/male.jpeg"
    copy_file "assets/female.jpg", "app/assets/images/female.jpg"

    copy_file "views/sessions/new.html.erb", "app/views/sessions/new.html.erb"
    directory "views/shared", "app/views/shared"
    directory "views/users", "app/views/users"
    directory "views/portraits", "app/views/portraits"
    directory "views/welcomes", "app/views/welcomes"
    directory "views/user_mailer", "app/views/user_mailer"
    directory "views/password_resets", "app/views/password_resets"
    directory "views/password_alters", "app/views/password_alters"
    directory "views/articles", "app/views/articles"
    directory "views/layouts", "app/views/layouts"
    directory "views/categories", "app/views/categories"
    directory "views/comments", "app/views/comments" 
    directory "views/notifications", "app/views/notifications"

    copy_file "mailers/user_mailer.rb", "app/mailers/user_mailer.rb"
    copy_file "uploaders/avatar_uploader.rb", "app/uploaders/avatar_uploader.rb"
    directory "views/kaminari", "app/views/kaminari"
    directory "migrate", "db/migrate"
    directory "models", "app/models"
    directory "controllers", "app/controllers"
    directory "config/initializers", "config/initializers"
    copy_file "config/locales/zh.yml", "config/locales/zh.yml"
  end

  desc "modify initializer file"
  def modify_initializer_file
    inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-'RUBY'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      post :authorize, :unauthorize, :forbidden, :unforbidden
    end
    get 'search', on: :collection
  end
  root 'welcomes#index'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :password_alters,     only: [:edit, :update]
  resources :portraits,           only: [:new, :create, :update]
  resources :articles do
    collection do
      delete :remove_select
    end
    member do
      get :release
      get :unrelease
    end
  end
  get 'articles_search', to: "welcomes#articles_search"
  get 'users_search', to: "welcomes#users_search"
  resources :categories
  resources :comments
  resources :notifications do
    get 'read', on: :collection
    get 'remove', on: :collection
  end
RUBY
    end

    inject_into_file 'app/assets/javascripts/application.js', after: "//= require turbolinks\n" do <<-'RUBY'
//= require jquery3
//= require popper
//= require bootstrap
//= require jcrop
//= require avatar
//= require select_all.js
//= require simplemde.min
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

    inject_into_file 'Gemfile', after: "#source 'https://rubygems.org'\n" do <<-'RUBY'
gem 'bootstrap', '~> 4.0.0'
gem 'font-awesome-rails'
gem 'bcrypt'
gem 'jquery-rails'
gem 'kaminari'
gem 'carrierwave'
gem 'mini_magick'
gem 'rails-assets-jcrop', source: 'https://rails-assets.org'
gem 'searchkick'
gem 'friendly_id'
gem 'babosa'
gem 'inky-rb', require: 'inky'
gem 'premailer-rails'
gem 'select_all-rails'
gem 'ancestry'
gem 'simplemde-rails'
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


    gsub_file 'config/environments/development.rb', 'config.action_mailer.raise_delivery_errors = false', 'config.action_mailer.raise_delivery_errors = true'
    
    inject_into_file 'config/environments/development.rb', after: "Rails.application.configure do\n" do <<-'RUBY'
  config.action_mailer.default_url_options = {host: "localhost:3000"}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    user_name: "zhengjiajun121",
    password: ENV['gmail_password'],
    authentication: "plain",
    enable_starttls_auto: true }
RUBY
  end

  inject_into_file 'config/initializers/assets.rb',
                    after: "# Rails.application.config.assets.precompile += %w( admin.js admin.css )\n" do <<-'RUBY'
Rails.application.config.assets.precompile += %w( foundation_emails.scss )
RUBY
  end

  end
end
