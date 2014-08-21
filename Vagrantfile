CLOUD_CONFIG_PATH = File.join(File.dirname(__FILE__), "docker", "user-data.sample")
VAGRANTFILE_API_VERSION = "2"

# Setup discovery token
$setup_cloud_config = <<SCRIPT
DISCOVERY_TOKEN=`curl -s https://discovery.etcd.io/new` && sed -e "s@#discovery: https://discovery.etcd.io/<token>@discovery: ${DISCOVERY_TOKEN}@g" /tmp/vagrantfile-user-data.sample > /tmp/vagrantfile-user-data
SCRIPT

$update_channel = "alpha"

Dotenv.load

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # use CoreOS stable box
  config.vm.box = "coreos-%s" % $update_channel
  config.vm.box_version = ">= 308.0.1"
  config.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % $update_channel

  # Setup resource requirements
  config.vm.provider :virtualbox do |v|
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    v.check_guest_additions = false
    v.functional_vboxsf     = false

    v.memory = 2048
    v.cpus = 2
    v.gui = false
  end

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  # need a private network for NFS shares to work
  config.vm.network :private_network, ip: "192.168.50.4"

  # Rails Server Port Forwarding
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # docker has already installed in CoreOS
  # config.vm.provision "docker"

  # Must use NFS for this otherwise rails
  # performance will be awful
  config.vm.synced_folder ".", "/app", id: "core", nfs: true, mount_options: ['nolock,vers=3,udp']

  if File.exist?(CLOUD_CONFIG_PATH)
    config.vm.provision :file, source: "#{CLOUD_CONFIG_PATH}", destination: "/tmp/vagrantfile-user-data.sample"
    config.vm.provision :shell, inline: $setup_cloud_config
    config.vm.provision :shell, inline: "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant", privileged: true
  end

  # Setup the containers when the VM is first
  # created
  config.vm.provision "shell" do |s|
    s.path = "docker/scripts/build.sh"
    s.args = "#{ENV['DOCKER_REPOSITORY_BUCKET']} #{ENV['AWS_ACCESS_KEY_ID']} #{ENV['AWS_SECRET_KEY']}"
  end

  # Make sure the correct containers are running
  # every time we start the VM.
  config.vm.provision "shell", run: "always" do |s|
    s.path = "docker/scripts/start.sh"
    s.args = "#{ENV['DOCKER_REPOSITORY_BUCKET']} #{ENV['AWS_ACCESS_KEY_ID']} #{ENV['AWS_SECRET_KEY']}"
  end
end
