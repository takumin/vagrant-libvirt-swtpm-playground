proxy_regex = /^(socks|https?):\/\/(?:([0-9a-zA-Z-_\.]+):([0-9a-zA-Z-_\.]+)@)?([0-9a-zA-Z-_\.]+)(?::([0-9]+))?.*/

unless node[:proxy].kind_of?(Hash) then
  node[:proxy] = {}
end
unless node[:proxy][:proto].kind_of?(String) then
  node[:proxy][:proto] = nil
end
unless node[:proxy][:user].kind_of?(String) then
  node[:proxy][:user] = nil
end
unless node[:proxy][:pass].kind_of?(String) then
  node[:proxy][:pass] = nil
end
unless node[:proxy][:host].kind_of?(String) then
  node[:proxy][:host] = nil
end
unless node[:proxy][:port].kind_of?(Integer) then
  node[:proxy][:port] = nil
end
unless node[:proxy][:bypass].kind_of?(Array) then
  node[:proxy][:bypass] = nil
end

if ENV['HTTP_PROXY'] then
  node[:proxy][:proto] ||= ENV['HTTP_PROXY'].gsub(proxy_regex, '\1')
  node[:proxy][:user]  ||= ENV['HTTP_PROXY'].gsub(proxy_regex, '\2')
  node[:proxy][:pass]  ||= ENV['HTTP_PROXY'].gsub(proxy_regex, '\3')
  node[:proxy][:host]  ||= ENV['HTTP_PROXY'].gsub(proxy_regex, '\4')
  node[:proxy][:port]  ||= ENV['HTTP_PROXY'].gsub(proxy_regex, '\5').to_i
  node[:proxy][:uri]   ||= ENV['HTTP_PROXY']
elsif ENV['http_proxy'] then
  node[:proxy][:proto] ||= ENV['http_proxy'].gsub(proxy_regex, '\1')
  node[:proxy][:user]  ||= ENV['http_proxy'].gsub(proxy_regex, '\2')
  node[:proxy][:pass]  ||= ENV['http_proxy'].gsub(proxy_regex, '\3')
  node[:proxy][:host]  ||= ENV['http_proxy'].gsub(proxy_regex, '\4')
  node[:proxy][:port]  ||= ENV['http_proxy'].gsub(proxy_regex, '\5').to_i
  node[:proxy][:uri]   ||= ENV['http_proxy']
elsif ENV['HTTPS_PROXY'] then
  node[:proxy][:proto] ||= ENV['HTTPS_PROXY'].gsub(proxy_regex, '\1')
  node[:proxy][:user]  ||= ENV['HTTPS_PROXY'].gsub(proxy_regex, '\2')
  node[:proxy][:pass]  ||= ENV['HTTPS_PROXY'].gsub(proxy_regex, '\3')
  node[:proxy][:host]  ||= ENV['HTTPS_PROXY'].gsub(proxy_regex, '\4')
  node[:proxy][:port]  ||= ENV['HTTPS_PROXY'].gsub(proxy_regex, '\5').to_i
  node[:proxy][:uri]   ||= ENV['HTTPS_PROXY']
elsif ENV['https_proxy'] then
  node[:proxy][:proto] ||= ENV['https_proxy'].gsub(proxy_regex, '\1')
  node[:proxy][:user]  ||= ENV['https_proxy'].gsub(proxy_regex, '\2')
  node[:proxy][:pass]  ||= ENV['https_proxy'].gsub(proxy_regex, '\3')
  node[:proxy][:host]  ||= ENV['https_proxy'].gsub(proxy_regex, '\4')
  node[:proxy][:port]  ||= ENV['https_proxy'].gsub(proxy_regex, '\5').to_i
  node[:proxy][:uri]   ||= ENV['https_proxy']
end

if ENV['NO_PROXY'] then
  node[:proxy][:bypass] ||= ENV['NO_PROXY'].split(',')
elsif ENV['no_proxy'] then
  node[:proxy][:bypass] ||= ENV['no_proxy'].split(',')
end
if ENV['NO_PROXY'] or ENV['no_proxy'] then
  node[:proxy][:bypass].push('localhost')      unless node[:proxy][:bypass].include?('localhost')
  node[:proxy][:bypass].push('127.0.0.0/8')    unless node[:proxy][:bypass].include?('127.0.0.0/8')
  node[:proxy][:bypass].push('10.0.0.0/8')     unless node[:proxy][:bypass].include?('10.0.0.0/8')
  node[:proxy][:bypass].push('100.64.0.0/10')  unless node[:proxy][:bypass].include?('100.64.0.0/10')
  node[:proxy][:bypass].push('172.16.0.0/12')  unless node[:proxy][:bypass].include?('172.16.0.0/12')
  node[:proxy][:bypass].push('192.168.0.0/16') unless node[:proxy][:bypass].include?('192.168.0.0/16')
end

if node[:proxy][:proto] then
  MItamae.logger.debug "Proxy Proto:   #{node[:proxy][:proto]}"
end
if node[:proxy][:user] then
  MItamae.logger.debug "Proxy User:    #{node[:proxy][:user]}"
end
if node[:proxy][:pass] then
  MItamae.logger.debug "Proxy Pass:    #{node[:proxy][:pass]}"
end
if node[:proxy][:host] then
  MItamae.logger.debug "Proxy Host:    #{node[:proxy][:host]}"
end
if node[:proxy][:port] then
  MItamae.logger.debug "Proxy Port:    #{node[:proxy][:port]}"
end
if node[:proxy][:bypass] then
  MItamae.logger.debug "Proxy ByPass:  #{node[:proxy][:bypass]}"
end
