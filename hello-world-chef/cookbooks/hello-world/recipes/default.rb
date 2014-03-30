#
# Cookbook Name:: hello-world
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

# XXX: Mock !!
node.default["cloudify"] = ({
  "blueprint_id" => "bp-007",
  "deployment_id" => "dep-007",
  "node_id" => "node-007",
  "properties" => ({
    "image_path" => "images/cloudify-logo.png",
    "port" => 80
  })
})

# apt - start
e = execute "apt-get update" do
  action :nothing
end
e.run_action(:run)
# apt - end

node.default["apache"]["listen_ports"] = [node["cloudify"]["properties"]["port"]]
include_recipe "apache2"

site_name = "hello-world-chef-site"
d = ::File.join(node["apache"]["docroot_dir"], site_name)
remote_directory d do
  source "www"
end

template ::File.join(d, "index.html") do
  source "index.html.erb"
  variables node["cloudify"]
end

web_app site_name do
  docroot d
end

apache_site site_name
