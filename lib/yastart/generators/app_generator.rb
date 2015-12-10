require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Yastart
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "postgresql",
                 desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    def finish_template
      invoke :yastart_customization
      super
    end

    def yastart_customization
      invoke :customize_gemfile
    end

    def customize_gemfile
      # TODO: Send this code to app_builder.rb and call replace_gemfile
      remove_file 'Gemfile'
      template 'Gemfile.erb', 'Gemfile'
    end

    def customize_generators
      # insert_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do
      #   "config.generators do |g|
      #     g.stylesheets  false
      #     g.javascripts  false
      #     g.helper       false
      #   end\n\n"
      # end
    end

  end
end
