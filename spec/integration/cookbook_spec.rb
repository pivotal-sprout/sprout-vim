require 'spec_helper'

describe 'sprout-vim' do
  before :all do
    expect(File).not_to be_exists("#{ENV['HOME']}/vim")
  end

  it 'converges' do
    expect(system('soloist')).to be_true
  end
end
