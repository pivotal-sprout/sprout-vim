require 'rake'
require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Run foodcritic && rubocop && spec:unit'
task default: %w(foodcritic rubocop spec:unit)

desc 'Run default && spec:integration'
task ci: %w(default spec:integration)

FoodCritic::Rake::LintTask.new do |t|
  t.options[:fail_tags] = ['any']
  t.options[:progress] = true
  t.options[:context] = true
end

RuboCop::RakeTask.new

namespace :spec do
  desc 'Run unit specs (ChefSpec)'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/**/*_spec.rb'
  end

  desc 'Run integration specs (Will actually execute recipe!)'
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/integration/**/*_spec.rb'
  end
end
