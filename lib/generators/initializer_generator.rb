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
    copy_file "views/layouts/application.html.erb", "app/views/layouts/application.html.erb"
    copy_file "controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
    copy_file "controllers/users_controller.rb", "app/controllers/users_controller.rb"
    copy_file "controllers/account_activations_controller.rb", "app/controllers/account_activations_controller.rb"
    copy_file "controllers/welcomes_controller.rb", "app/controllers/welcomes_controller.rb"
    copy_file "controllers/password_resets_controller.rb", "app/controllers/password_resets_controller.rb"
    copy_file "controllers/portraits_controller.rb", "app/controllers/portraits_controller.rb"
    copy_file "migrate/20180113142458_create_users.rb", "db/migrate/20180113142458_create_users.rb"
    copy_file "models/user.rb", "app/models/user.rb"
    copy_file "uploaders/avatar_uploader.rb", "app/uploaders/avatar_uploader.rb"
    copy_file "views/sessions/new.html.erb", "app/views/sessions/new.html.erb"
    copy_file "views/shared/_errors.html.erb", "app/views/shared/_errors.html.erb"
    copy_file "views/shared/_navbar.html.erb", "app/views/shared/_navbar.html.erb"
    copy_file "views/shared/_flash.html.erb", "app/views/shared/_flash.html.erb"
    copy_file "views/users/new.html.erb", "app/views/users/new.html.erb"
    copy_file "views/users/show.html.erb", "app/views/users/show.html.erb"
    copy_file "views/users/index.html.erb", "app/views/users/index.html.erb"
    copy_file "views/users/_authorize.html.erb", "app/views/users/_authorize.html.erb"
    copy_file "views/users/_unauthorize.html.erb", "app/views/users/_unauthorize.html.erb"
    copy_file "views/users/authorize.js.erb", "app/views/users/authorize.js.erb"
    copy_file "views/users/unauthorize.js.erb", "app/views/users/unauthorize.js.erb"
    copy_file "views/users/forbidden.js.erb", "app/views/users/forbidden.js.erb"
    copy_file "views/users/unforbidden.js.erb", "app/views/users/unforbidden.js.erb"
    copy_file "views/welcomes/_unforbidden.html.erb", "app/views/welcomes/_unforbidden.html.erb"
    copy_file "views/welcomes/_forbidden.html.erb", "app/views/welcomes/_forbidden.html.erb"
    copy_file "views/welcomes/_users_search.html.erb", "app/views/welcomes/_users_search.html.erb"
    copy_file "views/welcomes/_articles_search.html.erb", "app/views/welcomes/_articles_search.html.erb"
    copy_file "views/welcomes/_page.html.erb", "app/views/welcomes/_page.html.erb"
    copy_file "views/welcomes/_users.html.erb", "app/views/welcomes/_users.html.erb"
    copy_file "views/welcomes/_articles.html.erb", "app/views/welcomes/_articles.html.erb"
    copy_file "views/welcomes/_articles_search.html.erb", "app/views/welcomes/_articles_search.html.erb"
    copy_file "views/portraits/new.html.erb", "app/views/portraits/new.html.erb"
    copy_file "views/portraits/show.html.erb", "app/views/portraits/show.html.erb"
    copy_file "views/portraits/crop.html.erb", "app/views/portraits/crop.html.erb"
    copy_file "views/welcomes/index.html.erb", "app/views/welcomes/index.html.erb"
    copy_file "config/locales/zh.yml", "config/locales/zh.yml"
    copy_file "config/initializers/friendly_id.rb", "config/initializers/friendly_id.rb"
    copy_file "mailers/user_mailer.rb", "app/mailers/user_mailer.rb"
    copy_file "views/user_mailer/account_activation.html.inky", "app/views/user_mailer/account_activation.html.inky"
    copy_file "views/user_mailer/password_reset.html.inky", "app/views/user_mailer/password_reset.html.inky"
    copy_file "views/password_resets/edit.html.erb", "app/views/password_resets/edit.html.erb"
    copy_file "views/password_resets/new.html.erb", "app/views/password_resets/new.html.erb"
    copy_file "migrate/20180125114459_create_articles.rb", "db/migrate/20180125114459_create_articles.rb"
    copy_file "models/article.rb", "app/models/article.rb"
    copy_file "controllers/articles_controller.rb", "app/controllers/articles_controller.rb"
    copy_file "views/articles/new.html.erb", "app/views/articles/new.html.erb"
    copy_file "views/articles/show.html.erb", "app/views/articles/show.html.erb"
    copy_file "views/articles/index.html.erb", "app/views/articles/index.html.erb"
    copy_file "views/articles/_errors.html.erb", "app/views/articles/_errors.html.erb"
    copy_file "views/articles/_article.html.erb", "app/views/articles/_article.html.erb"
    copy_file "migrate/20180126084126_create_friendly_id_slugs.rb", "db/migrate/20180126084126_create_friendly_id_slugs.rb"
    copy_file "views/layouts/mailer.html.erb", "app/views/layouts/mailer.html.erb"
    copy_file "assets/foundation_emails.scss", "vendor/assets/stylesheets/foundation_emails.scss"
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
  resources :portraits,            only: [:new, :create, :show]
  resources :articles
  get 'articles_search', to: "welcomes#articles_search"
  get 'users_search', to: "welcomes#users_search"
RUBY
    end
 
    inject_into_file 'app/assets/javascripts/application.js', after: "//= require turbolinks\n" do <<-'RUBY'
//= require jquery3
//= require popper
//= require bootstrap
//= require jcrop
//= require avatar
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
