require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: %w(foodcritic rubocop spec:unit)
task ci: %w(default spec:integration)

desc 'Run foodcritic'
task :foodcritic do
  sh 'foodcritic . -f any'
end

Rubocop::RakeTask.new

namespace :spec do
  desc 'Run unit specs (ChefSpec)'
  task :unit do
    sh 'rspec spec/unit'
  end

  desc 'Run integration specs (Will actually execute recipe!)'
  task :integration do
    sh 'rspec spec/integration'
  end
end
