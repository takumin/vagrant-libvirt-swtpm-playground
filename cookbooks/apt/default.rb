#
# Apt Repo Proxy Access
#

apt_proxy = ''

if node[:proxy].kind_of?(Hash) and node[:proxy][:uri].kind_of?(String) and node[:proxy][:uri].length > 0
  apt_proxy = node[:proxy][:uri]
end

#
# Apt Repo Direct Access
#

apt_direct = []

case node[:apt_direct_access]
when String
  unless node[:apt_direct_access].empty?
    apt_direct << node[:apt_direct_access]
  end
when Array
  node[:apt_direct_access].each do |host|
    if host.kind_of?(String) and host.length > 0
      apt_direct << host
    end
  end
end

#
# Apt Configuration
#

template '/etc/apt/apt.conf' do
  owner 'root'
  group 'root'
  mode  '0644'
  variables({apt_proxy: apt_proxy, apt_direct: apt_direct})
end

#
# Apt Keyrings
#

apt_keyring 'Ubuntu-ja Archive Automatic Signing Key <archive@ubuntulinux.jp>' do
  finger '3B593C7BE6DB6A89FB7CBFFD058A05E90C4ECFEC'
  uri 'https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg'
end

apt_keyring 'Launchpad PPA for Ubuntu Japanese Team' do
  finger '59676CBCF5DFD8C1CEFE375B68B5F60DCDC1D865'
  uri 'https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg'
end

#
# Apt Repository
#

apt_repository 'Ubuntu Official Repository' do
  path '/etc/apt/sources.list'
  entry [
    {
      :default_uri => 'http://jp.archive.ubuntu.com/ubuntu',
      :mirror_uri  => "#{ENV['APT_REPO_URL_UBUNTU'] || node['apt-repo-url-local-ubuntu']}",
      :suite       => '###platform_codename###',
      :source      => true,
      :components  => [
        'main',
        'restricted',
        'universe',
        'multiverse',
      ],
    },
    {
      :default_uri => 'http://jp.archive.ubuntu.com/ubuntu',
      :mirror_uri  => "#{ENV['APT_REPO_URL_UBUNTU'] || node['apt-repo-url-local-ubuntu']}",
      :suite       => '###platform_codename###-updates',
      :source      => true,
      :components  => [
        'main',
        'restricted',
        'universe',
        'multiverse',
      ],
    },
    {
      :default_uri => 'http://jp.archive.ubuntu.com/ubuntu',
      :mirror_uri  => "#{ENV['APT_REPO_URL_UBUNTU'] || node['apt-repo-url-local-ubuntu']}",
      :suite       => '###platform_codename###-backports',
      :source      => true,
      :components  => [
        'main',
        'restricted',
        'universe',
        'multiverse',
      ],
    },
    {
      :default_uri => 'http://jp.archive.ubuntu.com/ubuntu',
      :mirror_uri  => "#{ENV['APT_REPO_URL_UBUNTU'] || node['apt-repo-url-local-ubuntu']}",
      :suite       => '###platform_codename###-security',
      :source      => true,
      :components  => [
        'main',
        'restricted',
        'universe',
        'multiverse',
      ],
    },
  ]
end

apt_repository 'Ubuntu Partner Repository' do
  path '/etc/apt/sources.list.d/ubuntu-partner.list'
  entry [
    {
      :default_uri => 'http://archive.canonical.com/ubuntu',
      :mirror_uri  => "#{ENV['APT_REPO_URL_PARTNER'] || node['apt-repo-url-local-partner']}",
      :suite       => '###platform_codename###',
      :source      => true,
      :components  => [
        'partner',
      ],
    },
  ]
end

apt_repository 'Ubuntu Japanese Team Repository' do
  path '/etc/apt/sources.list.d/ubuntu-ja.list'
  entry [
    {
      :default_uri => 'http://archive.ubuntulinux.jp/ubuntu',
      :mirror_uri  => "#{ENV['APT_REPO_URL_JA'] || node['apt-repo-url-local-ja']}",
      :suite       => '###platform_codename###',
      :source      => true,
      :components  => [
        'main',
      ],
    },
    {
      :default_uri => 'http://archive.ubuntulinux.jp/ubuntu-ja-non-free',
      :mirror_uri  => "#{ENV['APT_REPO_URL_JA_NON_FREE'] || node['apt-repo-url-local-ja-non-free']}",
      :suite       => '###platform_codename###',
      :source      => true,
      :components  => [
        'multiverse',
      ],
    },
  ]
end

#
# Event Handler
#

execute 'apt-get update' do
  action :nothing
  subscribes :run, 'template[/etc/apt/apt.conf]'
  subscribes :run, 'apt_repository[Ubuntu Official Repository]'
  subscribes :run, 'apt_repository[Ubuntu Partner Repository]'
  subscribes :run, 'apt_repository[Ubuntu Japanese Team Repository]'
end
