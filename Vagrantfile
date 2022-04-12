# This file is to setup Ubuntu VM servers
Vagrant.configure("2") do |config|
  vm_box = "ubuntu/xenial64"
  config.vm.define "admin" do |admin|
    admin.vm.box = vm_box
    admin.vm.hostname = 'ubuntu-xenial-admin'
    admin.vm.network "private_network", ip: "192.168.56.200"
    admin.vm.provision "shell", privileged: false,
      inline: <<-SCRIPT_DOC
        ssh-keygen -f ~vagrant/.ssh/id_rsa -t rsa -N ''
        cp -v ~vagrant/.ssh/id_rsa.pub /vagrant/admin_id_rsa.pub
      SCRIPT_DOC
    admin.vm.provision "shell",
      inline: <<-SCRIPT_DOC
        apt-get update
        apt-get install -y ansible
      SCRIPT_DOC
  end

  config.vm.define "db1" do |db1|
    db1.vm.box = vm_box
    db1.vm.hostname = 'ubuntu-xenial-db1'
    db1.vm.network "private_network", ip: "192.168.56.210"
    db1.vm.provision "shell", inline: "cat /vagrant/admin_id_rsa.pub >> ~vagrant/.ssh/authorized_keys"
    db1.vm.provision "shell",
      inline: <<-SCRIPT_DOC
        #apt-get update
        apt-get install -y python
        apt-get install -y postgresql
      SCRIPT_DOC
  end

  config.vm.define "app1" do |app1|
    app1.vm.box = vm_box
    app1.vm.hostname = 'ubuntu-xenial-app1'
    app1.vm.network "private_network", ip: "192.168.56.221"
    app1.vm.provision "shell", inline: "cat /vagrant/admin_id_rsa.pub >> ~vagrant/.ssh/authorized_keys"
    app1.vm.provision "shell",
      inline: <<-SCRIPT_DOC
        #apt-get update
        apt-get install -y python
      SCRIPT_DOC
  end

  config.vm.define "app2" do |app2|
    app2.vm.box = vm_box
    app2.vm.hostname = 'ubuntu-xenial-app2'
    app2.vm.network "private_network", ip: "192.168.56.222"
    app2.vm.provision "shell", inline: "cat /vagrant/admin_id_rsa.pub >> ~vagrant/.ssh/authorized_keys"
    app2.vm.provision "shell",
      inline: <<-SCRIPT_DOC
        #apt-get update
        apt-get install -y python
      SCRIPT_DOC
  end
end
