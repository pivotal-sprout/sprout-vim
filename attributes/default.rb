include_attribute 'sprout-base::home'

node.default['sprout']['vim']['config']['path'] = "#{node['sprout']['home']}/.vim"
node.default['sprout']['vim']['config']['repo'] = 'git://github.com/pivotalcommon/vim-config.git'
node.default['sprout']['vim']['config']['ref'] = 'master'
