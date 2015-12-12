module Yastart
  class AppBuilder < Rails::AppBuilder

    def readme
      template 'README.md.erb', 'README.md'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      template 'Gemfile.erb', 'Gemfile'
    end

    def replace_rakefile
      remove_file 'Rakefile.rake'
      template 'Rakefile.rake.erb', 'Rakefile.rake'
    end

    def replace_locals_file
      remove_file 'config/locales/en.yml'
      copy_file 'en.yml', 'config/locales/en.yml'
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

    def sample_data_file
      copy_file 'sample_data.rb', 'db/sample_data.rb'
    end

    def gitignore_files
      append_file '.gitignore', 'config/database.yml\n'
      append_file '.gitignore', 'public/assets/\n'
      append_file '.gitignore', '.rvmrc\n'
      append_file '.gitignore', '/public/cache\n'
      append_file '.gitignore', '/public/system/*\n'
      append_file '.gitignore', '.DS_Store\n'
      append_file '.gitignore', '**/.DS_Store\n'
      append_file '.gitignore', 'config/application.yml\n'
    end

    def activate_robots
      uncomment_lines 'public/robots.txt', /User-agent: */
      uncomment_lines 'public/robots.txt', /Disallow: */
    end

    def configure_simple_form
      bundle_command 'exec rails generate simple_form:install'
      #bundle_command 'exec rails generate figaro:install'
    end

    def copy_application_yml
      run 'cp config/database.yml config/database.sample.yml'
      create_file 'config/application.yml'
      run 'cp config/application.yml config/application.sample.yml'
    end

    def insert_into_gemfile(gem)
      append_file 'Gemfile', gem
    end

    def command_bundle_install
      # bundle_command 'install'
      run 'bundle install'
    end

    def create_user_model
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
          'config/routes.rb',
          config,
          after: "Rails.application.routes.draw do\n"
      )

      bundle_command "exec rails generate sorcery:install remember_me reset_password"
    end

    def create_mailer(name)
      bundle_command "exec rails generate mailer #{name}"
      create_file 'app/views/layouts/email_template.html.erb'
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
          'config/routes.rb',
          config,
          after: "Rails.application.routes.draw do\n"
      )
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
            before_filter :verify_adminprivate

          private
            def verify_admin
              redirect_to login_url unless current_user && current_user.admin?
            end
      RUBY

      insert_into_file(
          "app/controllers/#{name}/base_controller.rb",
          config,
          after: "#{name.camelcase}::BaseController < ApplicationController\n"
      )
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{Yastart::RUBY_VERSION}\n"
    end

    def setup_spring
      bundle_command "exec spring binstub --all"
    end

    def init_git
      run 'git init'
      git add: ".", commit: "-m 'initial commit'"
    end

  end
end