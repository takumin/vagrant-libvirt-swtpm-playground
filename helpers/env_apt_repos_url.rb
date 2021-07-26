if node[:go_apt_mirror].is_a?(Hash) and node[:go_apt_mirror][:enabled].is_a?(TrueClass) then
  if !node[:go_apt_mirror].key?(:config) or !node[:go_apt_mirror][:config].is_a?(Hash) then
    node[:go_apt_mirror][:config] = {}

    if !node[:go_apt_mirror][:config].key?(:dir) or !node[:go_apt_mirror][:config][:dir].is_a?(String) then
      node[:go_apt_mirror][:config][:dir] = '/var/spool/go-apt-mirror'
    end
  end
end

if node[:apt_mirror_config].is_a?(Hash) and node[:apt_mirror_config].size > 0 then
  if ENV['APT_DIRECT_ACCESS'].is_a?(String) and ENV['APT_DIRECT_ACCESS'].size > 0 then
    node[:apt_direct_access] = ENV['APT_DIRECT_ACCESS']
  end

  if ENV['APT_MIRROR_BASE_URL'].is_a?(String) and ENV['APT_MIRROR_BASE_URL'].match(/^(?:file|https?):\/\//) then
    node[:apt_mirror_base_url] = ENV['APT_MIRROR_BASE_URL']
  end

  if node[:apt_mirror_base_url].is_a?(String) and node[:apt_mirror_base_url].match(/^(?:file|https?):\/\//) then
    local_base_url = node[:apt_mirror_base_url]
    mirror_base_url = node[:apt_mirror_base_url]
  end

  if node[:go_apt_cacher].is_a?(Hash) and node[:go_apt_cacher][:enabled].is_a?(TrueClass) then
    local_base_url = "http://go-apt-cacher"
  end

  if node[:go_apt_mirror].is_a?(Hash) and node[:go_apt_mirror][:enabled].is_a?(TrueClass) then
    local_base_url = "file://#{node[:go_apt_mirror][:config][:dir]}"
  end

  node[:apt_mirror_config].sort.each do |k, v|
    if v.key?(:url) and v[:url].match(/^(?:file|https?):\/\//) then
      if local_base_url.is_a?(String) and !local_base_url.empty? then
        node["apt-repo-url-local-#{k}"] = "#{local_base_url}/#{k}"
      else
        node["apt-repo-url-local-#{k}"] = "#{v[:url]}"
      end

      if mirror_base_url.is_a?(String) and !mirror_base_url.empty? then
        node["apt-repo-url-mirror-#{k}"] = "#{mirror_base_url}/#{k}"
      else
        node["apt-repo-url-mirror-#{k}"] = "#{v[:url]}"
      end

      node["apt-repo-url-origin-#{k}"] = "#{v[:url]}"
    end
  end
end
