# vim: set ft=ruby :

require 'open-uri'
require 'fileutils'
require 'yaml'

# MItamae Github Release Tag
MITAMAE_VERSION ||= '1.12.7'

# MItamae CookBooks
MITAMAE_COOKBOOKS = [
  'roles/default.rb',
]

# Download Require Binary
[
  {
    :name => 'mitamae',
    :version => MITAMAE_VERSION,
    :urls => [
      "https://github.com/itamae-kitchen/mitamae/releases/download/v#{MITAMAE_VERSION}/mitamae-x86_64-linux",
    ],
  },
].each do |item|
  base_dir = File.join(File.expand_path(__dir__), '.bin', item[:name], item[:version])
  unless File.exist?(base_dir)
    FileUtils.mkdir_p(base_dir, mode: 0755)
  end

  item[:urls].each do |url|
    path = File.join(base_dir, item[:name])
    unless File.exist?(path)
      p "Download: #{url}"
      URI.open(url) do |res|
        IO.copy_stream(res, path)
      end
      FileUtils.chmod(0755, path)
    end
  end
end

# Require Minimum Vagrant Version
Vagrant.require_version '>= 2.2.17'

Vagrant.configure("2") do |config|
  # Require Plugins
  config.vagrant.plugins = ['vagrant-libvirt']

  # Ubuntu 20.04 Box
  config.vm.box = 'takumin/ubuntu2004'

  # Synced Directory
  config.vm.synced_folder '.', '/vagrant'

  # Libvirt Provider Configuration
  config.vm.provider :libvirt do |libvirt|
    # CPU
    libvirt.cpus = 2
    # Memory
    libvirt.memory = 1024
    # Monitor
    libvirt.graphics_type = 'spice'
    libvirt.graphics_ip = '127.0.0.1'
    libvirt.video_type = 'qxl'
    # TPM
    libvirt.tpm_model = "tpm-crb"
    libvirt.tpm_type = "emulator"
    libvirt.tpm_version = "2.0"
  end

  # MItamae Install
  config.vm.provision 'shell' do |shell|
    shell.name   = 'Install mitamae'
    shell.inline = <<~BASH
      if ! mitamae version > /dev/null 2>&1; then
        install -o root -g root -m 0755 /vagrant/.bin/mitamae/#{MITAMAE_VERSION}/mitamae /usr/local/bin/mitamae
      fi
    BASH
  end

  # MItamae Provision
  config.vm.provision 'shell' do |shell|
    shell.name   = 'Provision mitamae'
    shell.env = {
      'no_proxy'            => ENV['no_proxy'] || ENV['NO_PROXY'],
      'NO_PROXY'            => ENV['no_proxy'] || ENV['NO_PROXY'],
      'ftp_proxy'           => ENV['ftp_proxy'] || ENV['FTP_PROXY'],
      'FTP_PROXY'           => ENV['ftp_proxy'] || ENV['FTP_PROXY'],
      'http_proxy'          => ENV['http_proxy'] || ENV['HTTP_PROXY'],
      'HTTP_PROXY'          => ENV['http_proxy'] || ENV['HTTP_PROXY'],
      'https_proxy'         => ENV['https_proxy'] || ENV['HTTPS_PROXY'],
      'HTTPS_PROXY'         => ENV['https_proxy'] || ENV['HTTPS_PROXY'],
      'APT_DIRECT_ACCESS'   => ENV['APT_DIRECT_ACCESS'],
      'APT_MIRROR_BASE_URL' => ENV['APT_MIRROR_BASE_URL'],
    }
    shell.inline = <<~BASH
      cd /vagrant
      for i in #{MITAMAE_COOKBOOKS.join(' ')}; do
        mitamae local $(./scripts/inventories.sh) helpers/keepers.rb $i
      done
    BASH
  end

  # Guest Machine Definitions
  config.vm.define :master do |master|
    master.vm.hostname = "master.vagrant.internal"
  end
end
