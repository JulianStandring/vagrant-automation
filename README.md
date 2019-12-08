# Summary
A load balanced "Hello World" website project configured with Ansible using a Vagrant virtual environment.

100% Minimal Viable Product, it would need much more to be hardened and production ready. This is intended for demonstration only.

## Goal
To demonstrate an Infrastructure as Code solution using vagrant and ansible that runs a "Hello World" website.

This will consist of:
- 3 x Vagrant virtual machines (one loadbalancer and two webservers):
  - Using `ubuntu/bionic64` box type
  - Configured with static ip addresses
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

I used the following versions when writing this project.

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
- External links/reading that helped inform my understanding [tip: these might help you with any setup issues]
  - https://www.booleanworld.com/configure-nginx-load-balancer/
  - https://www.mydailytutorials.com/ansible-template-module-examples/
  - https://codelike.pro/how-to-configure-nginx-using-ansible-on-ubuntu/

# Run it
Assuming you have installed the relevant software lets go create.

## Steps
- **STEP 1**: Git clone to get the code
  - First of all clone this repo locally, e.g. `git clone git@github.com:JulianStandring/vagrant.git` _assuming you have ssh setup! (other download methods are available)_.
- **STEP 2**: Vagrant up
  - Make sure you're in the root of the cloned repo
  - Run `vagrant up`, this uses the `Vagrantfile` to start everything up
  - Wait. This will take some time to download all the necessary resources but should do everything you need.

Did you get any errors? :crossed_fingers:

:x: Hopefully the error messages helped. Please comment and get in touch if help is needed.

:green_heart: :green_heart: As expected, I mean what could have gone wrong? right? :sweat_smile: :relieved: :smile:

## Check it
Click this link, http://localhost:8080, you should see a Hello World page with a webserver name that changes with each refresh.

Also, take a look at the README under `/tests` this will go into more depth about what to check and what you should be looking for.


# Change it
Assuming everything worked you might be thinking about how to do more and where to look next. Let me explain how this project is laid out. I'll break it down into parts and tell you where to look to make certain types of changes.

## Folder structure
```
(root)
.
├── ansible
│  └── templates
└── tests
```

There's a `Vagrantfile` in the root folder. This defines the infrastructure and provisioning method.

As ansible is used for provisioning and configuring it gets it's own folder, `ansible`.

This `ansible` folder contains the yaml playbooks written for this project. There is also an `ansible/templates` folder. This contains text files that can be used by playbooks, in this case to configure nginx.

The `tests` folder contains ways to check what good looks like but is loosely coupled and relies more on manual effort. If required as part of an automated pipeline then git commit hooks could be used to trigger tests. This can help enforce consistency for a larger project.

## Vagrant
### Networking
Vagrant allows for plenty of networking options. In this case the port forwarding config (`forwarded_port`) acts as proxy, allowing access to the private network through only `vagrant ssh` commands or the exposed `8080` port that's forwarded to the loadbalancer and then load balanced to the web servers.

### Adding more machines
Virtual machines can be defined in many ways. In the `Vagrantfile` there is a `(1..2).each do |i|` block. This creates two webservers and could be easily changed to increase the number of webservers. This is a good example of how to avoid too much repetition.
However, it's not so straight forward. Other changes would be required due to the static IP configuration used in the `lb.nginx.conf.tmpl` file. Planning for these types of changes in advance can be time consuming and is not always necessary for an MVP. If more webservers were needed then this could be improved through ansible templates to dynamically update that part of the configuration. In this case having static IP addresses is clear, easy to understand but limiting.

If there was the addition of a new role, say a database, it could be provisioned in one of the two ways demonstrated in this Vagrantfile. Either individually or as a group. A set of ansible configuration to setup the database would also be needed.

Alternatively, each machine could have been created as one collection, then depending on the unique identifier, say the hostname number, different tasks could be run. This would mean only one `config.vm.define` block, simplifying the Vagrantfile and shifting the logic to ansible.
Doing this requires a different way of thinking about the vms. It might simplify the Vagrantfile but it might also complicated logic in another area, for example the use of templates could become complicated.

In this project both approaches are demonstrated.

### Provisioning
With Vagrant it's possible to use different provisioning methods. Ansible allows for continued management of the machines once they're created but in some cases other provisioning could be more appropriate. For example, using shell scripts to get something working before iterating onto a more refined solution.

## Ansible
There's a README under `/ansible` that explains more about that code.

## NGINX
NGINX is a flexible webserver that can also be configured to run as a loadbalancer. Other software could have been used but this was picked as it's fairly easy to get started with and has a lot of flexibility.

Each config file was taken from the default installation, with the comment lines removed, i.e. `grep -v ^.*#`. The comments are useful and worth reading but it's much smaller and easier to view the config with them gone. So, with these abbreviated config files the following lines were added to create the loadbalancer.

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

The upstream webservers had an `index.html` file dropped into the webroot at `/var/www/html/`. This html file was customised before being written to the webservers so that each one is unique, making it possible to check that the loadbalancer is doing it's thing.

This consititues a very simple "app". More complex websites could be deployed in a similar way, using file copies and templating. If you have an existing app there's a high chance that ansible will have a module that could help manage it.
