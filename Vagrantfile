Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: "echo Hello"
  config.vm.provider "parallels"
 
  config.vm.define "k8s-master-1" do |master|
    master.vm.box = "whoisshyam/ubuntu-20.04-05"
    master.vm.hostname = "k8s-master-1"
    master.vm.provider "parallels" do |prl|
      prl.memory = 2048
      prl.cpus = 2
      prl.name = "k8s-master-1"
      prl.update_guest_tools = true
    end
    master.vm.network "private_network", type: "dhcp"
    master.vm.network "forwarded_port", guest: 22, host: 2711, auto_correct: true
    master.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/me.pub"
    master.vm.provision "file", source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/me"
    master.vm.provision "shell", inline: <<-SHELL
      cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
    SHELL
    master.vm.provision "install_crio", type: "shell", path: "scripts/install_crio.sh" do |s|
      s.args = ["xUbuntu_20.04","1.25"]
    end
    master.vm.provision "install_k8s", type: "shell", path: "scripts/install_k8s.sh"
    master.vm.boot_timeout = 600
  end
 

 (1..2).each do |i|
  config.vm.define "k8s-worker-#{i}" do |worker|
    worker.vm.box = "whoisshyam/ubuntu-20.04-05"
    worker.vm.hostname = "k8s-worker-#{i}"
    worker.vm.provider "parallels" do |prl|
      prl.memory = 4096
      prl.cpus = 2
      prl.name = "k8s-worker-#{i}"
      prl.update_guest_tools = true
    end
    worker.vm.network "private_network", type: "dhcp"
    worker.vm.network "forwarded_port", guest: 22, host:  "#{2711 + i}", auto_correct: true
    worker.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/me.pub"
    worker.vm.provision "shell", inline: <<-SHELL
      cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
    SHELL
    worker.vm.provision "install_crio", type: "shell", path: "scripts/install_crio.sh" do |s|
      s.args = ["xUbuntu_20.04","1.25"]
    end
    worker.vm.provision "install_k8s", type: "shell", path: "scripts/worker_install_k8s.sh"
    worker.vm.boot_timeout = 600
  end
end
end
