require 'unit/spec_helper'

RSpec.describe 'sprout-vim::default' do
  let(:runner) { ChefSpec::SoloRunner.new }

  before do
    stub_command(/test /)
  end

  it 'includes all the recipes' do
    runner.converge(described_recipe)
    expect(runner).to include_recipe('sprout-vim::macvim')
    expect(runner).to include_recipe('sprout-vim::tmux')
    expect(runner).to include_recipe('sprout-vim::config')
  end
end
