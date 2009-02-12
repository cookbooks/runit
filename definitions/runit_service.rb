define :runit_service, :directory => nil, :only_if => false do
  
  params[:directory] ||= node[:runit_sv_dir]
  
  sv_dir_name = "#{params[:directory]}/#{params[:name]}"
  
  directory sv_dir_name do
    mode 0755
    action :create
  end
  
  directory "#{sv_dir_name}/log" do
    mode 0755
    action :create
  end
  
  directory "#{sv_dir_name}/log/main" do
    mode 0755
    action :create
  end
  
  template "#{sv_dir_name}/run" do
    mode 0755
    source "sv-#{params[:name]}-run.erb"
  end
  
  template "#{sv_dir_name}/log/run" do
    mode 0755
    source "sv-#{params[:name]}-log-run.erb"
  end
  
  link "/etc/init.d/#{params[:name]}" do
    to node[:runit_sv_bin]
  end
  
  link "#{node[:runit_service_dir]}/#{params[:name]}" do 
    to "#{sv_dir_name}"
  end
  
  service params[:name] do
    supports :restart => true, :status => true
    action :nothing
  end
  
  #execute "#{params[:name]}-down" do
  #  command "/etc/init.d/#{params[:name]} down"
  #  only_if do params[:only_if] end
  #end
  
end
