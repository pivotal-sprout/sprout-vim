require 'unit/spec_helper'

describe 'sprout-vim::default' do
  let(:runner) { ChefSpec::Runner.new }

  before do
    stub_command(/test /)
  end

  it 'includes all the recipes' do
    runner.converge(described_recipe)
    expect(runner).to include_recipe('sprout-osx-apps::macvim')
    expect(runner).to include_recipe('sprout-vim::tmux')
    expect(runner).to include_recipe('sprout-vim::config')
  end
end
