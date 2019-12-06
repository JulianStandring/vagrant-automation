Vagrant.configure("2") do |config|

  config.vm.define "loadbalancer" do |lb|
    lb.vm.box = "ubuntu/bionic64"
    lb.vm.network "forwarded_port", guest: 80, host: 8080, id: "loadbalancer"
    lb.vm.network "private_network", ip: "192.168.10.10"

    config.vm.provision "ansible" do |ansible|
#      ansible.verbose = "v"
      ansible.become = true
      ansible.playbook = "./ansible/helloworld.yml"
    end
  end

  (1..2).each do |i|
    config.vm.define "webserver-#{i}" do |webserver|
      webserver.vm.box = "ubuntu/bionic64"
      webserver.vm.network "private_network", ip: "192.168.10.2#{i}"

      webserver.vm.provision "ansible" do |ansible|
#        ansible.verbose = "v"
        ansible.become = true
        ansible.playbook = "./ansible/helloworld.yml"
      end
    end
  end

end
