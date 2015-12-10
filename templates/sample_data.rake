namespace :db do
  desc 'Load sample data from db/sample_data.rb'
  task sample_data: :environment do
    seed_file = File.join(Rails.root, 'db', 'sample_data.rb')
    load(seed_file) if File.exist?(seed_file)
  end

  desc 'Drop, create, migrate, seed and sample_data'
  task bootstrap: [:drop, :create, :migrate, :seed, :sample_data]
end

task bs: 'db:bootstrap'
