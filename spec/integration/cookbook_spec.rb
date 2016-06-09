require 'spec_helper'

RSpec.describe 'sprout-vim' do
  let(:dotvim_directory) { File.expand_path('~/.vim') }

  before do
    brew_installed = system('which brew')

    if brew_installed
      brew_prefix = Bundler.with_clean_env { `brew --prefix`.chomp }

      mvim_filename = File.join(brew_prefix, 'bin', 'mvim')
      tmux_filename = File.join(brew_prefix, 'bin', 'tmux')

      expect(File.exist?(mvim_filename)).to be_false, 'Please run `brew uninstall macvim`'
      expect(File.exist?(tmux_filename)).to be_false, 'Please run `brew uninstall tmux`'
    end

    expect(system("sudo rm -rf #{dotvim_directory}")).to be_true, "Unable to `rm -rf #{dotvim_directory}`"
  end

  it 'installs MacVim, adds the .vim directory, and installs tmux' do
    expect(system('soloist')).to be_true

    expect(File.exist?(mvim_filename)).to be_true
    expect(File.exist?(dotvim_directory)).to be_true
    expect(File.exist?(tmux_filename)).to be_true
  end
end
