package 'tmux'

cookbook_file "#{node['sprout']['home']}/.tmux.conf" do
  source 'tmux.conf'
  mode '0644'
  owner node['current_user']
end

sprout_base_bash_it_custom_plugin 'source_vim_tmux_config.bash'
