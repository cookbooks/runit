case node[:platform]
when "debian","ubuntu"
  execute "start-runsvdir" do
    command "start runsvdir"
    action :nothing
  end
  
  package "runit" do
    action :install
    notifies :run, resources(:execute => "start-runsvdir")
  end
    
  if node[:platform_version].to_f < 8.04
    remote_file "/etc/event.d/runsvdir" do
      source "runsvdir"
      mode 0644
      notifies :run, resources(:execute => "start-runsvdir")
      only_if do File.directory?("/etc/event.d") end
    end
    
    file "/etc/inittab" do
      action :touch
    end
  end
end


