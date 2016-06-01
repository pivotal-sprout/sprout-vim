ruby_block "ensure sprout-vim can manage #{node['sprout']['vim']['config']['path']}" do
  missing = "test ! -d #{node['sprout']['vim']['config']['path']}"
  config_exist = "cd #{node['sprout']['vim']['config']['path']}"
  matching_remote = "test -d .git && (git remote -v show | grep -q #{node['sprout']['vim']['config']['repo']})"

  not_if "#{missing} || (#{config_exist} && #{matching_remote})"

  block do
    raise "Rename or delete #{node['sprout']['vim']['config']['path']} if you want to use this recipe"
  end
end

preexisting = File.exist?(File.join(node['sprout']['vim']['config']['path'], '.git'))

package 'git'

git node['sprout']['vim']['config']['path'] do
  repository node['sprout']['vim']['config']['repo']
  branch 'master'
  revision node['sprout']['vim']['config']['ref']
  action :sync
  user node['sprout']['user']
  enable_submodules true
end

install_file = File.join(node['sprout']['vim']['config']['path'], 'bin', 'install')
execute('./bin/install') do
  cwd node['sprout']['vim']['config']['path']
  user node['sprout']['user']
  not_if { preexisting }
  only_if { File.executable?(install_file) }
end

update_file = File.join(node['sprout']['vim']['config']['path'], 'bin', 'update')
execute('./bin/update') do
  cwd node['sprout']['vim']['config']['path']
  user node['sprout']['user']
  only_if { preexisting }
  only_if { File.executable?(update_file) }
end

%w(vimrc gvimrc).each do |vimrc|
  file_to_link = "#{node['sprout']['vim']['config']['path']}/#{vimrc}"
  link "#{node['sprout']['home']}/.#{vimrc}" do
    to file_to_link
    owner node['sprout']['user']
    not_if { File.symlink?(file_to_link) }
  end
end

cookbook_file "#{node['sprout']['home']}/.vimrc.local" do
  source 'vimrc.local'
  action :create_if_missing
  owner node['sprout']['user']
end
