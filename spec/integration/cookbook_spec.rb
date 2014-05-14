require 'spec_helper'

describe 'sprout-vim' do
  it 'installs MacVim, adds the .vim directory, and installs tmux' do
    brew_prefix = Bundler.with_clean_env { `brew --prefix`.chomp }

    mvim_filename = File.join(brew_prefix, 'bin', 'mvim')
    dotvim_directory = File.expand_path('~/.vim')
    tmux_filename = File.join(brew_prefix, 'bin', 'tmux')

    expect(File.exist?(mvim_filename)).to be_false, 'Please run `brew uninstall macvim`'
    expect(File.exist?(dotvim_directory)).to be_false, 'Please run `rm -rf ~/.vim`'
    expect(File.exist?(tmux_filename)).to be_false, 'Please run `brew uninstall tmux`'

    expect(system('soloist')).to be_true

    expect(File.exist?(mvim_filename)).to be_true
    expect(File.exist?(dotvim_directory)).to be_true
    expect(File.exist?(tmux_filename)).to be_true
  end
end
