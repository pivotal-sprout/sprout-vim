require 'spec_helper'

RSpec.describe 'sprout-vim' do
  let(:dotvim_directory) { File.expand_path('~/.vim') }
  let(:brew_installed_mvim) { File.join('/usr/local/bin/mvim') }
  let(:brew_installed_tmux) { File.join('/usr/local/bin/tmux') }

  before do
    expect(File).not_to exist(brew_installed_mvim)
    expect(File).not_to exist(brew_installed_tmux)
    expect(File).not_to exist(dotvim_directory)
  end

  it 'installs MacVim, adds the .vim directory, and installs tmux' do
    expect(system('soloist')).to be_truthy

    expect(File).to exist(brew_installed_mvim)
    expect(File).to exist(brew_installed_tmux)
    expect(File).to exist(dotvim_directory)
  end
end
