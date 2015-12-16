module Yastart
  class AppBuilder < Rails::AppBuilder

    def readme
      template 'README.md.erb', 'README.md'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      template 'Gemfile.erb', 'Gemfile'
    end

    def replace_english_locale_file
      # remove_file "config/locales/en.yml"
      # copy_file "en.yml.erb", "config/locales/en.yml"
      template 'en.yml.erb', 'config/locales/en.yml'
    end

    def configure_generators
      config = <<-RUBY
        config.generators do |g|
          g.stylesheets  false
          g.javascripts  false
          g.helper       false
        end
      RUBY

      insert_into_file(
        'config/application.rb',
        config,
        after: "class Application < Rails::Application\n")
    end

    def sample_data_rake_task
      copy_file "sample_data.rake", "lib/tasks/sample_data.rake"
    end

    def sample_data_file
      copy_file "sample_data.rb", "db/sample_data.rb"
    end

    def setup_bundler_audit
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
      append_file "Rakefile", %{\ntask default: "bundler:audit"\n}
    end

    def copy_bundler_audit
      copy_file "bundler_audit.rake", "bundler_audit.rake"
    end

    def replace_application_helper
      remove_file "app/helpers/application_helper.rb"
      copy_file "application_helper.rb", "app/helpers/application_helper.rb"
    end

    def gitignore_files
      append_file '.gitignore', "config/database.yml\n"
      append_file '.gitignore', "public/assets/\n"
      append_file '.gitignore', ".rvmrc\n"
      append_file '.gitignore', "/public/cache\n"
      append_file '.gitignore', "/public/system/*\n"
      append_file '.gitignore', ".DS_Store\n"
      append_file '.gitignore', "**/.DS_Store\n"
      append_file '.gitignore', "config/application.yml\n"
    end

    def configure_robots_file
      uncomment_lines "public/robots.txt", /User-agent: */
      uncomment_lines "public/robots.txt", /Disallow: */
    end

    def configure_simple_form
      bundle_command "exec rails generate simple_form:install --bootstrap"
    end

    def copy_application_yml
      remove_file 'config/database.yml'
      template 'database.yml', 'config/database.yml'
      run "cp config/database.yml config/database.sample.yml"

      template 'application.yml', 'config/application.yml'
      run "cp config/application.yml config/application.sample.yml"
    end

    def insert_into_gemfile(gem)
      append_file "Gemfile", gem
    end

    def command_bundle_install
      run "bundle install"
    end

    def create_user
      config = <<-RUBY
        # USER ROUTES
        # ----------------------------------------------------------------------------
        delete 'logout'               => 'sessions#destroy',     as: 'logout'
        get    'login'                => 'sessions#new',         as: 'login'
        get    'signup'               => 'registrations#new',    as: 'signup'
        get    'profile'              => 'registrations#edit',   as: 'profile'
        post   'profile'              => 'registrations#update', as: 'update_profile'
        get    'paswords/:token/edit' => 'passwords#edit',       as: 'change_password'
        resource  :password,        only: [:new, :create, :edit, :update]
        resources :registrations, except: [:index, :show, :destroy]
        resources :sessions
      RUBY

      insert_into_file(
        "config/routes.rb",
        config,
        after: "Rails.application.routes.draw do\n")

      bundle_command "exec rails generate sorcery:install remember_me reset_password"
    end

    def create_mailer(name)
      bundle_command "exec rails generate mailer #{name}"
      remove_file "views/layouts/mailer.text.erb"
      copy_file "mailer.html.erb", "views/layouts/mailer.html.erb"
      insert_into_file "app/mailers/#{name}.rb", before: "default from: 'from@example.com'" do
        "\n layout 'email_template'"
      end
    end

    def create_public_controller(name)
      bundle_command "exec rails generate controller #{name} home"
      config = <<-RUBY
        # PUBLIC ROUTES
        # ----------------------------------------------------------------------------
        root to: "#{name}\#home"
      RUBY

      insert_into_file(
        "config/routes.rb",
        config,
        after: "Rails.application.routes.draw do\n")
    end

    def create_admin_controller(name)
      bundle_command "exec rails generate controller #{name}/base"
      bundle_command "exec rails generate controller #{name}/dashboard show"

      route "\n# ADMIN ROUTES  # ----------------------------------------------------------------------------
      scope module: '#{name}', path: 'adm1nistr8tion', as: 'admin' do
        root to: 'dashboard#show', as: :dashboard
      end\n"
    end

    def config_admin_controller(name)

      config = <<-RUBY
        before_action :verify_admin

        private

          def verify_admin
            redirect_to login_url unless current_user && current_user.admin?
          end
      RUBY

      insert_into_file(
        "app/controllers/#{name}/base_controller.rb",
        config,
        after: "#{name.camelcase}::BaseController < ApplicationController\n")
    end

    def config_production(name)
      default_email = '#{ENV["DEFAULT_EMAIL_SENDER"]}'
      config = <<-RUBY
        Rails.application.routes.default_url_options[:host] = ENV['DOMAIN']

        config.action_mailer.default_url_options = { host: ENV['DOMAIN'] }
        config.action_mailer.asset_host = ENV['HOST']
        config.action_mailer.delivery_method = :smtp

        config.action_mailer.smtp_settings = {
          :address              => ENV['SMTP_HOST'],
          :port                 => ENV['SMTP_PORT'],
          :user_name            => ENV['SMTP_USERNAME'],
          :password             => ENV['SMTP_PASSWORD']
        }

        # Exceptions handling
        config.middleware.use ExceptionNotification::Rack,
        :email => {
          :email_prefix         => "[Exception] ",
          :sender_address       => %{"[#{name}] Exception Notifier" <#{default_email}>},
          :exception_recipients => ENV['ADMIN_EMAIL']
        }
      RUBY

      insert_into_file(
        "config/environments/production.rb",
        config,
        after: "config.active_record.dump_schema_after_migration = false\n"
      )
    end

    def test_helper(helper)
      remove_file "test/test_helper.rb"
      copy_file helper, "test/test_helper.rb"
    end

    def setup_spring
      bundle_command "exec spring binstub --all"
    end

    def create_partials_directory
      empty_directory "app/views/application"
    end

    def copy_seeds
      remove_file "db/seeds.rb"
      copy_file 'seeds.rb', "db/seeds.rb"
    end

    def copy_header
      copy_file "_header.html.erb", "app/views/application/_header.html.erb"
    end

    def copy_footer
      copy_file "_header.html.erb", "app/views/application/_footer.html.erb"
    end

    def copy_flash
      copy_file "_header.html.erb", "app/views/application/_flash.html.erb"
    end

    def copy_application_layout
      remove_file "app/views/layouts/application.html.erb"
      copy_file "application.html.erb", "app/views/application/application.html.erb"
    end

    def add_api_gems
      insert_into_file(
        "Gemfile",
        "gem 'rack-cors', require: 'rack/cors'"
      )
    end

    def create_api_controller
      empty_directory "app/controllers/api"
      empty_directory "app/controllers/api/v1"
      copy_file "api_base_controller.rb", "app/controllers/api/base_controller.rb"
    end

    def configure_api_routes
      config = <<-RUBY
        # API ROUTES
        # ----------------------------------------------------------------------------
        namespace :api, defaults: {format: 'json'} do
          scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
            resources :orders, only: [:create]
          end
        end
      RUBY

      insert_into_file(
        "config/routes.rb",
        config,
        after: "Rails.application.routes.draw do\n")
    end

    def configure_api_settings
      config = <<-RUBY
        config.middleware.use Rack::Cors, logger: (-> { Rails.logger }) do
          allow do
            origins '*'
            resource '/api/*', headers: :any,
              methods: [:get, :post, :options], credentials: true, max_age: 0
          end
        end
      RUBY

      insert_into_file(
        "config/application.rb",
        config,
        after: "# config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]\n\n")
    end

    def create_api_views
      empty_directory "app/views/api"
      empty_directory "app/views/api/v1"
    end

    def init_git
      run 'git init'
      git add: ".", commit: "-m 'initial commit'"
    end

    def outro
      say 'All set. Run rake bs to get started'
    end
  end
end
