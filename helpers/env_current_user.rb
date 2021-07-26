node[:current]         ||= Hashie::Mash.new
node[:current][:user]  ||= ENV['SUDO_USER'] || ENV['USER']
node[:current][:home]  ||= node[:user][node[:current][:user]][:directory]
node[:current][:shell] ||= node[:user][node[:current][:user]][:shell]
node[:current][:uid]   ||= node[:user][node[:current][:user]][:uid]
node[:current][:gid]   ||= node[:user][node[:current][:user]][:gid]
