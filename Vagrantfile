Vagrant.configure("2") do |config|

  config.vm.define "load_balancer" do |lb|
    lb.vm.box = "ubuntu/bionic64"
    lb.vm.network "forwarded_port", guest: 80, host: 8080, id: "load_balancer"
    lb.vm.network "private_network", ip: "192.168.10.10"

    config.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.become = true
      ansible.playbook = "./ansible/lb.yml"
    end
  end
  
  config.vm.define "web1" do |web1|
    web1.vm.box = "ubuntu/bionic64"
    web1.vm.network "private_network", ip: "192.168.10.20"

    config.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.become = true
      ansible.playbook = "./ansible/web.yml"
    end
  end
  
  config.vm.define "web2" do |web2|
    web2.vm.box = "ubuntu/bionic64"
    web2.vm.network "private_network", ip: "192.168.10.21"

    config.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.become = true
      ansible.playbook = "./ansible/web.yml"
    end
  end
  
end
