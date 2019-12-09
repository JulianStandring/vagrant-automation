# Ansible
When `vagrant up`, or `vagrant provision` is run, the boxes in the Vagrantfile call an ansible file as part of the provisioning step.
Ansible works by using playbooks, these are yaml files that define what something should look like. They're used to install, configure and generally manage anything that has an ssh connection. In this project the playbooks install software, copy files for configuration, add variables to write out a host specific file and also edit the sudoers file.

Ansible can also be run locally and on demand, it's not only used when provisioning a box.
To run ansible manually you need to provide an inventory file, thankfully vagrant creates one of these when provisioning so the following example should work as a way to replay the same playbook.

 `ansible-playbook -i ../.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory helloworld.yml -b`

## Extending
Using ansible beyond a basic project requires some organisation but can greatly reduce manual effort. Keeping organised by splitting up the code and using templates can help a great deal.

The `helloworld.yml` uses `import_playbook` to reference other playbooks. This demonstrates one way to extend configuration. Simply write a new playbook and add it to the one called by vagrant, in this project, `helloworld.yml`.

### Modules
Ansible has a lot of modules, for example `copy`, `template`, `lineinfile`. The use of other modules can allow for simplified onfiguration steps and thereby simpler management of that infrastructure with code. It's also possible to version control the infrastructure config.

### Limitations
Not everything will work all of the time and ansible only manages what you tell it to. Things on the system can still change and may go unnoticed for some time. Manual intervention is still highly likely if not highly infrequent. It's not the silver bullet for all infrastructure managment.

In short, ansible works well as part of a good ecosystem. 

## Troubleshooting
Beyond the install docs from ansible here are a few things that I found useful to know while setting this up and wrote down as notes.
[tip: Always read the error messages and hopefully some searches for them will provide workarounds or solutions]

### Getting decent output
Have you tried using verbose mode? If you check the provisioning block in the `Vagrantfile` there's an `ansible.verbose = "v"` line commented out. Try uncommenting it and hopefully it'll help you with more detail into what's happening.

Try running parts separately as this might return more output. Use verbose switches where possible and also check error logs if applicable. Walk through each step and try running it by itself until you get to the bit that breaks.

If you're running ansible manually you can add `-v` switches to get verbose output.

### I can't run ansible because ssh hosts can't be added to the approved list ?!?!
Are you in the correct folder? Try setting the following to false, `ANSIBLE_HOST_KEY_CHECKING`, e.g. `ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ... ...`. Alternatively this is set in `ansible/ansible.cfg` but only used if running the command from that working directory.

### How do I create an inventory file when using vagrant ?!?!
When you run `vagrant provision` an inventory is generated that you can reference. It is: `.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory`.
Use the `-i` flag to reference it as an inventory file, e.g. `ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory playbook.yml -b`.
