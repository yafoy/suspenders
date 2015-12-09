module Yastart
  class AppBuilder < Rails::AppBuilder
    def replace_gemfile
      puts 'Replace GemFile'
      remove_file 'Gemfile'
      template 'Gemfile.erb', 'Gemfile'
    end
  end
end