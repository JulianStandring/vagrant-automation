# Summary
A load balanced "Hello World" website project configured with Ansible using a Vagrant virtual environment.

100% Minimal Viable Product, it would needs much more to be hardened and production ready. This is intended for demonstration only.

- Use Vagrant to create three virtual machines (one load balancer and two web servers):
  - Configure networking
  - Configure VM Access (`vagrant ssh`, no password for sudo if admin group or vagrant user)
  - Provision Ansible and run playbooks
- Use Ansible to:
  - Install NGINX
  - Configure NGINX as a load balancer
  - Configure NGINX as a web server (i.e. modify the home page)
  - Enforce configuration (i.e. run manually)


# Read it
## This isn't
- Secure
- Scalable
- The only way of doing it
- Instruction for "how to setup a terminal or install software" (if there are ommissions that would be helpful please let me know)
- The only resource you should use (see links)

## Installation
This project was completed using MacOS High Sierra (10.13) and I use `brew` as a package manager, for example, I was able to install ansible by running `brew install ansible` ([see here for brew](https://brew.sh/)) and check details by running `brew info ansible`.

The following software is central to this project. If you can get version numbers using the shell command then you should be ok to continue and everything should be installed correctly. If you're having trouble please check the maintainer's website.

Software | Shell command | Version used here | Maintainer Website
-----------|--------------------|--------|-----
VirtualBox | `virtualbox --help` | 6.0.14  | [website link](https://www.virtualbox.org/wiki/Downloads)
Vagrant | `vagrant --version` | 2.2.6  | [website link](https://www.vagrantup.com/downloads.html)
Ansible | `ansible --version` | 2.9.2  | [website link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-on-macos)

## Links
Additional links that might also be worth reading:
- [Ansible Vagrant Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vagrant.html)
- [Vagrant Docs](https://www.vagrantup.com/docs/)
- [NGINX Docs](https://nginx.org/en/docs/)
- Something something... medium? blogs? [WIP - check browser history when done]


# Run it
Assuming you have installed the relevant software and have an idea what we're trying to do then let's create.

- STEP 1: Git clone
  - First of all clone this repo locally, e.g. `git clone https://github.com/JulianStandring/vagrant.git`.
- STEP 2: Vagrant up
  - Make sure you're in the root of the repo you've just cloned and then run `vagrant up`. This will take some time to download all the necessary resources but should do everything you need.

Three virtual machines are created, assigned ip addresses, ports are forwarded from your computer to the virtual machines and ansible runs some configuration tasks like installing NGINX.

## Ansible
When you ran `vagrant up` the Vagrantfile used ansible to configure the virtual machines. You can also run these tasks or playbooks again to enforce configuration or make changes. You can run these manually. [WIP - need some examples]

## Troubleshooting
Beyond the maintainer install docs here are a few things that I found useful to know while setting this up and wrote down as notes. Always read the error messages and hopefully some searches for them will provide workarounds or solutions if you have problems setting up this project.

### I can't run ansible because ssh hosts can't be added to the approved list?!?!
Are you in the correct folder? Try setting the following to false, `ANSIBLE_HOST_KEY_CHECKING`, e.g. `ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ... ...`. Alternatively this is set in `ansible/ansible.cfg` but only used if running the command from that working directory.

### How do I create an inventory file when using vagrant?!?!
When you run `vagrant provision` an inventory is generated that you can reference. It is: `.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory`. Use the `-i` flag to reference it, e.g. `ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory playbook.yml -b`.


# Test it 
What behaviours do we care about? a.k.a. Tests that tell us what we should expect when doing specific things. What follows are some examples written in a [Given-When-Then](https://www.agilealliance.org/glossary/gwt/) format, these are only examples and pretty much mirror the bullet points in the summary.

## Page Content
**Given** a user accesses the website on http://localhost:8080

 **and** uses cURL or a web browser

**Then** they get served a "Hello World" page

## Load Balancer
**Given** traffic goes through a load balancer

 **and** HTTP requests are balanced using round-robin

**Then** the page will be served by alternating webservers

## HTTP Health Check
**Given** we have two web servers behind a load balancer

**When** we send them HTTP requests avoiding the loadbalancer

**Then** we get a 200 response from both

## Config management
**Given** we use ansible to ensure configuration is applied

**When** running ansible-playbooks repeatedly

**Then** changes are successfully applied

## VM Spec
**Given** that we expect a particular base image to be used when creating the virtual machines

**When** we run `vagrant up`

**Then** the expected base image is used
