
 # active ssl module

execute "enable module" do
	command "a2enmod ssl"
	action :run
end

# restart service apache

service "apache2" do
	action [:enable, :start]
end

# cerate self signed certificate

directory "/etc/apache2/ssl" do
	#cwd "/etc/apache2/"
        mode "755"
	recursive true
end


# location to place our key and certificate

#execute "create and manage key & certificate" do
#	command "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt"
#        action :run
#end

# copy apache.key

#execute "copy apache.key" do
#	command "cp -R /home/vagrant/apache.key /etc/apache2/ssl/apache.key"
#	action :run
#end


#copy apache.cert

#execute "copy apache.key" do
#        command "cp -R /home/vagrant/apache.crt /etc/apache2/ssl/apache.key"
#        action :run
#end

# enable mpm module

execute "enable-event" do
  command "a2enmod mpm_event"
  action :nothing
end

cookbook_file "/etc/apache2/mods-available/mpm_event.conf" do
  source "mpm_event.conf"
  mode "0644"
  notifies :run, "execute[enable-event]"
end



# configure apache to ssl

template "/etc/apache2/sites-available/default-ssl.conf" do
	source "default-ssl.conf.erb"
	variables ({
		:ServerAdmin => "#{node['apache2']['ServerAdmin']}" ,
		:ServerName => "#{node['apache2']['ServerName']}" ,
		:ServerAlias => "#{node['apache2']['ServerAlias']}" ,
		:DocumentRoot => "#{node['apache2']['DocumentRoot']}" ,
		:SSLCertificateFile => "#{node['apache2']['SSLCertificateFile']}" ,
		:SSLCertificateKeyFile => "#{node['apache2']['SSLCertificateKeyFile']}" 
})
end

# turm keepalive off

execute "keepalive" do
  command "sed -i 's/KeepAlive On/KeepAlive Off/g' /etc/apache2/apache2.conf"
  action :run
end

# enable ssl virtual host

execute "enable sites" do
	command " a2ensite default-ssl.conf"
	action :run
end

# restart service apache

service "apache2" do
	action :restart
end







