#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
 
 #package 'mysql-server' do
 # action :install
 #end

 #service 'mysqld' do
 # action [:start, :enable]
 #end
 
#package "gcc"
#package "gcc-c++"
#package "make"
#package "openssl-devel"
#package "pcre-devel"

mysql_root_pwd = "ADMINPASSWORD"
mysql_default_db = "waman"
mysql_config_file = "/etc/mysql/my.cnf"
 
#version = "5.6.26-1"
#bash "install_mysql_from_source" do
#  cwd Chef::Config['file_cache_path']
#  code <<-EOH
#    wget http://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-#{version}.el6.src.rpm
#    rpm -Uvh MySQL-5.6/MySQL-#{version}.el6.src.rpm
#	cd /home/vagrant/rpmbuild/SOURCES/mysql-5.6.26
#    ./configure && make && make install	
#  EOH
#  not_if "test -f /usr/local/nginx/sbin/nginx"
#end
 
 package "mysql-server" do
   action :install
end
 
service "mysqld" do
  service_name "mysqld"
 
  supports [:restart, :reload, :status]
  action [:start, :enable]
end
 
# set the root password
execute "/usr/bin/mysqladmin -uroot password #{mysql_root_pwd}" do
  not_if "/usr/bin/mysqladmin -uroot -p#{mysql_root_pwd} status"
end
 
# create the default database
execute "/usr/bin/mysql -uroot -p#{mysql_root_pwd} -e 'CREATE DATABASE IF NOT EXISTS #{mysql_default_db}'"
 
# grant privileges to the user so that he can get access from the host machine
execute "/usr/bin/mysql -uroot -p#{mysql_root_pwd} -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '#{mysql_root_pwd}' WITH GRANT OPTION;\""
 
#execute "sed -i 's/127.0.0.1/0.0.0.0/g' #{mysql_config_file}" do
  #not_if "cat #{mysql_config_file} | grep 0.0.0.0"
#end

service "mysqld" do
  action :restart
end