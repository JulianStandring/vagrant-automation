# Summary
A load balanced "Hello World" website project configured with Ansible using a Vagrant virtual environment.

100% Minimal Viable Product, it would needs much more to be hardened and production ready. This is intended for demonstration only.

## Goal
To demonstrate an Infrastructure as Code solution using vagrant and ansible that runs a "Hello World" website.

This will consist of
- 3 x Vagrant virtual machines (one loadbalancer and two webservers):
  - Using `ubuntu/bionic64` box type
  - Configured with static ips
  - Configured with port forwarding
  - Provisioned using Ansible
- Ansible used for configuration management:
  - Installing and configuring NGINX
    - as a loadbalancer
    - as a webserver
  - Configure VM Access (`vagrant ssh`, no password for sudo if admin group or vagrant user)
  - Enforce configuration (i.e. show how ansible can make changes)

# Read it
## This isn't
- Secure
- Scalable
- The only way of doing it
- Instructions on "how to setup your terminal or install software"
- The only resource you should use (see links)

## What do you need to run it?
This project was witten using MacOS High Sierra (10.13) and `brew` as a package manager, for example, ansible could be installed by running `brew install ansible` and version checked by running `brew info ansible` ([see here for brew](https://brew.sh/)).

The following software is central to this project but this project also assumes you have at least intermediate knowledge of a shell terminal. If you can run the shell commands successfully then the software should be installed ok. This means you can continue and everything should hopefully work. If you're having trouble please check the maintainer's website for install instructions.

I used the following versions when testing this project worked.
Software | Shell command | Version used here | Maintainer Website
-----------|--------------------|--------|-----
VirtualBox | `virtualbox --help` | 6.0.14  | [website link](https://www.virtualbox.org/wiki/Downloads)
Vagrant | `vagrant --version` | 2.2.6  | [website link](https://www.vagrantup.com/downloads.html)
Ansible | `ansible --version` | 2.9.2  | [website link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-on-macos)

## Links
Additional links that might also be worth reading:
- [Vagrant Docs](https://www.vagrantup.com/docs/)
- [Ansible Vagrant Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vagrant.html)
- [NGINX Docs](https://nginx.org/en/docs/)
- External links/reading that helped inform my understanding and might help you with setup issues
  - https://www.booleanworld.com/configure-nginx-load-balancer/
  - https://www.mydailytutorials.com/ansible-template-module-examples/
  - https://codelike.pro/how-to-configure-nginx-using-ansible-on-ubuntu/

# Run it
Assuming you have installed the relevant software and feel ready to go then let's create.

## Steps
- STEP 1: Git clone to get the code
  - First of all clone this repo locally, e.g. `git clone git@github.com:JulianStandring/vagrant.git` _assuming you have ssh setup! (other download methods are available)_.
- STEP 2: Vagrant up
  - Make sure you're in the root of the cloned repo
  - Run `vagrant up`, this uses the `Vagrantfile` to start everything up
  - Wait. This will take some time to download all the necessary resources but should do everything you need.

Did you get any errors? :crossed_fingers:
:x: Hopefully the error messages helped. Please comment and get in touch if help is needed.
:green_heart: As expected, I mean what could have gone wrong? right? :relieved:

## Check it
Take a look at the README under `/tests`. It suggests what to do other than checking, http://localhost:8080.


# Change it
Assuming everything worked you might be thinking about how to do more and where to look next. Let me explain how this project is laid out. Break it down into components and tell you where to look to make certain types of changes.

## Folder structure
```
(root)
.
├── ansible
│  └── templates
└── tests
```

There's a `Vagrantfile` in the root folder. This defines the infrastructure and provisioning method.

As ansible is used for provisioning and configuring it gets it's own folder, `ansible`. This contains the yaml playbooks written for this project. Under this there is a `templates` folder. This contains files that can be used by playbooks, in this case to configure nginx.

The `tests` folder contains ways to check what good looks like but is loosely coupled and relies more on manual effort. If automated git commit hooks could be used to trigger them and if they were to fail so would the commit creation. This can help enforce consistency for a larger project.

## Vagrant
### Adding more machines
Virtual machines can be defined in many ways. In the `Vagrantfile` there is a `(1..2).each do |i|` block. This can easily be used to increase the number of webservers created.
However, other changes would be required due to the static IP configuration that's used in the `lb.nginx.conf.tmpl`. Planning for these types of changes in advance can be time consuming and not necessary for an MVP. If this were to change then this could be improved by using templates to dynamically update the configuration based on the number of webservers created.

If the addition of a database was required it could be provisioned in one of the two ways demonstrated. To configure the database a set of ansible playbooks would be required too. Most changes once the vms and networking is set by vagrant can be made by ansible.

## Ansible
There's a README under `/ansible` that explains more about that code.

## NGINX
NGINX is a flexible webserver that can also be configured to run as a loadbalancer. Other software could have been used but this was picked as it's fairly easy to get started with and has a lot of flexibility.

Each config file was taken from the default installation, with the comment lines removed, i.e. `grep -v ^.*#`. The comments have useful information but it's much smaller and easier to read with them gone. With these abbreviated config files the following lines were added:

To `nginx.conf` aka `lb.nginx.conf.tmpl` (includes line numbers):
```
 12         upstream helloworld {
 13           server 192.168.10.21:80;
 14           server 192.168.10.22:80;
 15         }
```

To `sites-available/helloworld` aka `lb.sites-enabled.tmpl` (includes line numbers):
```
 13                 proxy_pass http://helloworld;
```
