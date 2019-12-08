# Summary
A load balanced "Hello World" website project configured with Ansible using a Vagrant virtual environment.

Everything can be brought up and tested using the `go_button.sh` automation script. Alternatively, parts can be run separately.

100% Minimal Viable Product, it would need much more to be hardened and production ready. This is intended for demonstration only.

## Goal
To demonstrate an IaC (Infrastructure as Code) solution using vagrant and ansible that runs a static "Hello World" page and uses basic tests to check it work.

This will consist of:
- 3 x Vagrant virtual machines (one loadbalancer and two webservers):
  - Using `ubuntu/bionic64` box type
  - Configured with static ip addresses
  - Configured with port forwarding
  - Provisioned using Ansible
- Ansible used for configuration management:
  - Installing and configuring NGINX
    - as a loadbalancer
    - with a custom page
  - Configuring sudoers to allow admin group NOPASSWD
  - Enforce configuration (i.e. show how ansible can make changes in an idempotent way)
    - repeated runs of `vagrant provision`
    - manual running of ansible playbooks

# Read it
## This isn't
- Secure
- Scalable
- The only way of doing it
- Instructions on "how to setup your terminal or install software"
- The only resource you should use (see links)

## What do you need? (dependencies)
### Computer
This project was witten using MacOS High Sierra (10.13) and `brew` as a package manager ([see here for brew](https://brew.sh/)). Brew can install most software from the command line. For example, ansible can be installed by running `brew install ansible` and it's version checked by running `brew info ansible`. Brew is not required to run this project.

### Software Dependencies
There is an assumption that the reader has at least intermediate knowledge of using a command line and terminal or shell. If you can get version numbers then you can continue and everything should hopefully work. If you're having trouble please check the maintainer's website for install instructions. It is essential this software is working before you continue.

I used the following versions when writing this project.

Software | Shell command to get version | Version used here | Maintainer Website
-----------|--------------------|--------|-----
VirtualBox | `virtualbox --help` | 6.0.14  | [website link](https://www.virtualbox.org/wiki/Downloads)
Vagrant | `vagrant --version` | 2.2.6  | [website link](https://www.vagrantup.com/downloads.html)
Ansible | `ansible --version` | 2.9.2  | [website link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-on-macos)
Bash | `bash --version` | 3.2.57 | Any compatible terminal window, shipped with the OS, should be sufficient (iTerm2 was used to write this project).

### Reading and useful links
Additional links that might also be worth reading:
- [Vagrant Docs](https://www.vagrantup.com/docs/)
- [Ansible Vagrant Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vagrant.html)
- [NGINX Docs](https://nginx.org/en/docs/)
- [Ansible lineinfile module (sudoers example)](https://docs.ansible.com/ansible/latest/modules/lineinfile_module.html)
- External links/reading that helped inform my understanding [tip: these might help you with any setup issues]
  - https://duckduckgo.com : for most searches
  - https://www.booleanworld.com/configure-nginx-load-balancer/
  - https://www.mydailytutorials.com/ansible-template-module-examples/
  - https://codelike.pro/how-to-configure-nginx-using-ansible-on-ubuntu/


# Run it
Assuming you have installed the relevant software lets go!

## Get the code
- Clone the repo to get the code
  - First of all clone this repo locally, e.g. `git clone git@github.com:JulianStandring/vagrant.git` _assuming you have ssh setup! (other download methods are available)_.

## Full Automation
- Run the pipeline script in the root, `./go_button.sh`.

This will:
- Run some lint tests, to test the playbook syntax
- Bring up the vagrant environment
- Run some tests

This can take some time, watch and read the output.

For a full cycle, including clean up, run the pipline script with an option, `./go_button.sh --create-destroy`.

## Manual Steps
- Run `vagrant up` while in the root
- Check the URLs and do manual checks and tests
- Run `vagrant destroy` and delete some temp files to clean up

## Troubleshooting
Did you get any errors? :crossed_fingers: :pray:

:x: Yes I did!! :x: Hopefully the error messages were clear. Please comment and get in touch if help is needed and you get stuck.

:green_heart: No errors. :green_heart: As expected, I mean what could have gone wrong? right? :sweat_smile: :relieved: :smile:

If you get in a mess and things aren't working please try the following:
1. Delete the repo and clone it again (i.e. a fresh start)
1. Run the pipeline script, the `go_button.sh`, with the clean up option.
1. Raise an issue and get in touch.
1. Tell me how to improve it.

# Check it
Click this link, http://localhost:8080, you should see a Hello World page with a webserver name that changes with each refresh.

If you're using the `go_button.sh` then tests are run automatically. Also check the README under the `./tests/` folder for other suggestions.

# Change it
Assuming everything worked you might be thinking about how to do more and modify this. Let me explain how I laid out this project.

## Folder structure
```
(root)
.
├── ansible
│  └── templates
└── tests
```

### root
The idea is to keep this fairly clear and make sure that any code is organised in an easy to search way.

Aside from this `README.md`, there's a `Vagrantfile` here. This defines the infrastructure and provisioning method.

The automation pipeline script is also here, `go_button.sh`. This is one place to kick everything off.

### ansible
Ansible relies on ssh and yaml. It relies on lots of playbooks that carry out tasks. As it can get complex it gets it's own folder.

There is also a `README.md` here and this explains specifics about this `ansible` folder and the yaml playbooks written for this project.

### ansible/templates
This contains files that can be sourced by playbooks, in this case to configure nginx and the static web page.

### tests
This folder contains code and a README.md. The code is a bash script. If a specific testing language was used it would be given a folder to contain the tests. There are different ways that the running of tests can be automated, for example, checking syntax could easily be done using [git hooks](https://githooks.com/).

Using tests helps enforce consistency for a larger project but are only as good as they are. A test for an HTTP 200 OK response might make you think the website is functioning but what if the content is what you actually care about?

Testing, monitoring and observability are closely related. In this case the tests are simple and used for demonstration.

## Vagrant
### Networking
In this case static IP addresses were assigned and port forwarding put in place for accessing the loadbalancer (`forwarded_port`).

The port forwarding allows access to a `private_network` through a defined port (8080). This then hits nginx and nginx passes the request to one of the configured webservers.

Direct access to port 80 on the webservers would show the same home page but this is not possible except through the exposed port. So, all web traffic has to go through the loadbalancer.

To ssh onto these machines the `vagrant ssh` command is needed. This saves you the trouble of figuring out how vagrant has connected all the vms through one network interface. So, to login to each host you can use the inventory name, there are three (`loadbalancer`, `webserver-1` and `webserver-2`) and the `vagrant ssh` command, e.g. `vagrant ssh loadbalancer`.

### Adding more machines
Simply repeating the loadbalancer block in the `Vagrantfile` and changing some words will get you another machine. I chose to show two different ways of doing this. For a larger project the method depends on where you want to push the logic, the discussion of "Pets Vs. Cattle" comes to mind. Anyway, 3 nodes could have been created in a loop or with individual blocks. How to split this up for a complex project can be a challenge.

The loop is writte using a `(1..2).each do |i|` block. This creates two webservers and could be easily changed to increase the number of webservers later.

This is a good example of avoiding repetition. However, just bumping the number wouldn't be enough. In this project updates to the `nginx.conf` would be needed to extend the upstream "helloworld" group. This could be done dynamically using ansible templates and with more work it would be possible to get the webserver group to increase on demand. In cloud environments like AWS this is known as auto-scaling and is a bit beyond the scope of this project.

### Configuration aka Provisioning
With Vagrant it's possible to use different provisioning methods. Ansible is only one of these. As an alternative a bash script could have been used to make all the same changes. Overtime that might become harder to use but for small projects can be quite effective.

Ansible also allows for continued management of the machines once they're created. It's possible to setup playbooks to run on schedules and enforce configuration or updates. Read more about ansible and this project in the "Ansible" section.

## Ansible
Please check the README in the `/ansible` folder.

## NGINX
NGINX is a flexible webserver that can also be configured to run as a loadbalancer. This makes it an HTTP proxy server. It takes HTTP traffic, checks it's config and sends that HTTP traffic onto somewhere else. To setup a dynamic web application nginx is typically just used as a proxy, i.e. traffic -> nginx -> web app.

The "app" in this project is two webservers serving a static page. The page does change but only because it's being load balanced. Please check nginx docs for more details on it's various uses. Paid versions do exist and your milage may vary.

In this project each config file was taken from the default installation, with the comment lines removed, i.e. `grep -v ^.*#`. It's smaller and easier to view this way. So, with these abbreviated config files being used as templates the following lines were also added to create/configure the loadbalancer.

To `nginx.conf` aka `lb.nginx.conf.tmpl`:
```
         upstream helloworld {
           server 192.168.10.21:80;
           server 192.168.10.22:80;
         }
```

To `sites-available/helloworld` aka `lb.sites-enabled.tmpl`:
```
                 proxy_pass http://helloworld;
```

A static web page, i.e the `index.html`, was dropped into the webroot at `/var/www/html/`. This html file was customised before being written to the webservers so that each one is unique, making it possible to check that the loadbalancer is doing it's thing.
