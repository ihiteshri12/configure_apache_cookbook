# updating system

#execute "update" do
#	command "apt-get update"
#end

# installing apache

package "apache2" do
	action :install
end

# starting service apache

service "apache2" do
	action [:enable, :start]
end


