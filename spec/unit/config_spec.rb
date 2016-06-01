require 'unit/spec_helper'

RSpec.describe 'sprout-vim::config' do
  let(:runner) { ChefSpec::SoloRunner.new }

  before do
    stub_command(/test /)
  end

  context 'when there is already a ~/.vim' do
    before do
      runner.node.set['sprout']['vim']['config']['path'] = '/dest_dir'
      runner.node.set['sprout']['vim']['config']['repo'] = 'a@b.git'

      stub_command(/test /).and_return(true)
    end

    it 'fails' do
      pending 'cannot make it fail the not_if'

      expect do
        runner.converge(described_recipe)
      end.to raise_error(/Rename or delete/)
    end
  end

  describe 'cloning the repo with the vim config files' do
    it 'clones pivotal/vim-config by default' do
      runner.converge(described_recipe)
      expect(runner).to sync_git('/home/fauxhai/.vim').with(
        branch: 'master',
        revision: 'master',
        repository: 'https://github.com/pivotal/vim-config.git',
        user: 'fauxhai',
        enable_submodules: true
      )
    end

    it 'allows a different repo to be set' do
      runner.node.set['sprout']['vim']['config']['repo'] = 'foo://bar.com/baz.git'
      runner.converge(described_recipe)
      expect(runner).to sync_git('/home/fauxhai/.vim').with(
        repository: 'foo://bar.com/baz.git'
      )
    end

    it 'allows the repo to be installed in an arbitrary location' do
      runner.node.set['sprout']['vim']['config']['path'] = '/foo/bar/baz'
      runner.converge(described_recipe)
      expect(runner).to sync_git('/foo/bar/baz')
    end

    it 'allows setting the revision' do
      runner.node.set['sprout']['vim']['config']['ref'] = 'abc123456'
      runner.converge(described_recipe)
      expect(runner).to sync_git('/home/fauxhai/.vim').with(
        revision: 'abc123456'
      )
    end
  end

  describe 'installing/updating the configuration' do
    let(:install_executable?) { true }
    let(:update_executable?) { true }
    let(:repo_exist?) { false }
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/home/fauxhai/.vim/.git').and_return(repo_exist?)
      allow(File).to receive(:executable?).with('/home/fauxhai/.vim/bin/install').and_return(install_executable?)
      allow(File).to receive(:executable?).with('/home/fauxhai/.vim/bin/update').and_return(update_executable?)
    end

    context 'when the repo was not previously checked out' do
      let(:repo_exist?) { false }

      context 'and the install script exists and is executable' do
        let(:install_executable?) { true }

        it 'runs the bin/install script' do
          runner.converge(described_recipe)
          expect(runner).to run_execute('./bin/install').with(
            cwd: '/home/fauxhai/.vim',
            user: 'fauxhai'
          )
        end
      end

      context 'but there is no executable install script' do
        let(:install_executable?) { false }

        it 'does not attempt to run it' do
          runner.converge(described_recipe)
          expect(runner).to_not run_execute('./bin/install')
        end
      end

      it 'does not run the bin/update script' do
        runner.converge(described_recipe)
        expect(runner).to_not run_execute('./bin/update')
      end
    end

    context 'when the repo already exists' do
      let(:repo_exist?) { true }

      context 'and the update script exists and is executable' do
        let(:update_executable?) { true }

        it 'runs the bin/update script' do
          runner.converge(described_recipe)
          expect(runner).to run_execute('./bin/update').with(
            cwd: '/home/fauxhai/.vim',
            user: 'fauxhai'
          )
        end
      end

      context 'but there is no executable update script' do
        let(:update_executable?) { false }

        it 'does not attempt to run it' do
          runner.converge(described_recipe)
          expect(runner).to_not run_execute('./bin/update')
        end
      end

      it 'does not run the bin/install script' do
        runner.converge(described_recipe)
        expect(runner).to_not run_execute('./bin/install')
      end
    end
  end

  describe 'symlinking the ~/.vim ~/.vimrc ~/vimrc ~/.gvmirc ~/gvimrc files' do
    it 'creates a symlink for ~/.vimrc and ~/.gvimrc' do
      runner.converge(described_recipe)
      expect(runner).to create_link('/home/fauxhai/.vimrc').with(to: '/home/fauxhai/.vim/vimrc')
      expect(runner).to create_link('/home/fauxhai/.gvimrc').with(to: '/home/fauxhai/.vim/gvimrc')
    end

    it 'does not create the symlink if the destination file is not a symlink' do
      allow(File).to receive(:symlink?).with('/home/fauxhai/.vim/vimrc').and_return(true)
      allow(File).to receive(:symlink?).with('/home/fauxhai/.vim/gvimrc').and_return(false)
      runner.converge(described_recipe)
      expect(runner).to_not create_link('/home/fauxhai/.vimrc').with(to: '/home/fauxhai/.vim/vimrc')
      expect(runner).to create_link('/home/fauxhai/.gvimrc').with(to: '/home/fauxhai/.vim/gvimrc')
    end
  end

  it 'creates a ~/.vimrc.local' do
    runner.converge(described_recipe)
    expect(runner).to create_cookbook_file_if_missing('/home/fauxhai/.vimrc.local')
  end
end
