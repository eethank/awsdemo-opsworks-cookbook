
package "haproxy" do
  action :install
end

service "haproxy" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

service "monit" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template '/etc/failure.sh' do
  source 'failure.sh.erb'
  variables({
    :instance_id => search('aws_opsworks_instance', 'self:true').first['instance_id'],
    :region => search('aws_opsworks_stack').first['region']
            })
  owner 'root'
  group 'root'
  mode 0755
end

template '/etc/monit.d/hpfailwatch.monitrc' do
  source 'hpfailwatch.monitrc.erb'
  owner 'root'
  group 'root'
  mode 0440
  notifies :reload, "service[monit]", :immediately
end

