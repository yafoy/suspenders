require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Yastart
  class AppGenerator < Rails::Generators::AppGenerator

    class_option :database, type: :string, aliases: "-d", default: "postgresql",
                 desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :skip_test_unit, type: :boolean, aliases: "-T", default: true,
                 desc: "Skip Test::Unit files"

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: true,
                 desc: "Don't run bundle install"

    def finish_template
      invoke :yastart_customization
      super
    end

    def yastart_customization
      invoke :customize_gemfile
      invoke :customize_locale_file
      invoke :customize_rake_tasks
      invoke :configure_app
      invoke :setup_gitignore
      invoke :setup_user
      invoke :generate_public_controller
      invoke :generate_admin_controller
      invoke :generate_api
      invoke :configure_views
      invoke :config_production_env
      invoke :init_git
      invoke :all_set_up
    end

    def customize_gemfile
      build :replace_gemfile
      bundle_command 'install'
      build :configure_simple_form
    end

    def customize_rake_tasks
      build :sample_data_rake_task
    end

    def customize_locale_file
      build :replace_english_locale_file
    end

    def configure_app
      build :configure_generators
      build :sample_data_file
      build :copy_application_yml
      build :configure_robots_file
    end

    def configure_views
      build :create_partials_directory
      build :copy_header
      build :copy_footer
      build :copy_flash
      build :copy_application_layout
    end

    def setup_gitignore
      build :gitignore_files
    end

    def setup_user
      if yes? 'Do you need users? (y/N)'
        build :create_user_model
        build :sorcery_test_helper
        invoke :generate_mailer
      end
    end

    def generate_mailer
      if yes? 'Do you need a mailer? (y/N)'
        name = ask('What should it be called? [user_mailer]').underscore
        name = 'user_mailer' if name.blank?
        build :create_mailer, name
      end
    end

    def generate_public_controller
      if yes? 'Do you want to generate a public controller? (y/N)'
        name = ask('What should it be called? [pages]').underscore
        name = 'pages' if name.blank?
        build :create_public_controller, name
      end
    end

    def generate_admin_controller
      if yes? 'Do you want to generate an admin controller? (Y/n)'
        name = ask('What should it be called? [admin]').underscore
        name = 'admin' if name.blank?
        build :create_admin_controller, name
        build :config_admin_controller, name
      end
    end

    def generate_api
      if yes? 'Do you want to scaffold API base? (Y/n)'
        build :add_api_gems
        build :create_api_controller
        build :configure_api_routes
        build :configure_api_settings
        build :create_api_views
      end
    end

    def config_production_env
      build :config_production, app_name
    end


    def init_git
      build :init_git
    end

    def all_set_up
      build :outro
    end

    protected

    def get_builder_class
      Yastart::AppBuilder
    end
  end
end
