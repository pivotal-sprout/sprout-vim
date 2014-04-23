ruby_block "ensure sprout-vim can manage #{node['sprout']['vim']['config']['path']}" do
  missing = "test ! -d #{node['sprout']['vim']['config']['path']}"
  config_exist = "cd #{node['sprout']['vim']['config']['path']}"
  matching_remote = "test -d .git && (git remote -v show | grep -q #{node['sprout']['vim']['config']['repo']})"

  not_if "#{missing} || (#{config_exist} && #{matching_remote})"

  block do
    fail "Rename or delete #{node['sprout']['vim']['config']['path']} if you want to use this recipe"
  end
end

package 'git'

git node['sprout']['vim']['config']['path'] do
  repository node['sprout']['vim']['config']['repo']
  branch 'master'
  revision node['sprout']['vim']['config']['ref']
  action :sync
  user node['current_user']
  enable_submodules true
end

%w(vimrc gvimrc).each do |vimrc|
  link "#{node['sprout']['home']}/.#{vimrc}" do
    to "#{node['sprout']['vim']['config']['path']}/#{vimrc}"
    owner node['current_user']
    not_if { File.symlink?("#{node['sprout']['vim']['config']['path']}/#{vimrc}") }
  end
end

file "#{node['sprout']['home']}/.vimrc.local" do
  action :touch
  owner node['current_user']
  not_if { File.exist?("#{node['sprout']['home']}/.vimrc.local") }
end
