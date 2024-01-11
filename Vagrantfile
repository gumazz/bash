# -*- mode: ruby -*- 
# vi: set ft=ruby : vsa
Vagrant.configure(2) do |config| 
 config.vm.box = "centos/7" 
 config.vm.box_version = "2004.01" 
 config.vm.provider "virtualbox" do |v| 
 v.memory = 256 
 v.cpus = 1 
 end 
 config.vm.define "bash" do |bash| 
 bash.vm.network "private_network", ip: "192.168.50.10",  virtualbox__intnet: "net1" 
 bash.vm.hostname = "bash" 
 bash.vm.provision "shell", path: "bash_vm_configuration.sh"
 end 
end 
