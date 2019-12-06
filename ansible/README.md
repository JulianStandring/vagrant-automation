# Ansible
When you ran `vagrant up` the Vagrantfile used ansible to configure the virtual machines. You can also run these tasks or playbooks again to enforce configuration or make changes. With more complex projects an inventory would be maintained for different roles and targetting of playbooks. In this simple project there is only one playbook in use.

Examples:
 `ansible-playbook -i ../.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory helloworld.yml -b`
 `vagrant provision`

## Extending
Using ansible beyond a basic project requires some organisation but can greatly reduce manual effort. Keeping organised by splitting up the code and using templates can help a great deal.

The `helloworld.yml` uses `import_playbook` to reference the nginx playbook. This demonstrates a way that you can extend the configuration. Say you were to write an additional playbook that improves the project, it can be easily provisioned by adding it to the entry point file (`helloworld.yml`).

Copying files to replace defaults is easy enough but not very flexible. This is done using the `copy` module, for example, when copying the replacement `nginx.conf`.

The `template` module is potentially more useful. This allowed a dynamic `inventory_hostname` to be added to the static web page. Different content could be catered for allowing one template for many different roles. In this case it was a clear indicator of which webserver served the web page. Adding a `vars:` block would allow specific variable replacement, there is also a concept of `facts` that can be queried to use in templates. All of which can provide for most use cases.

## Troubleshooting
Beyond the install docs from ansible here are a few things that I found useful to know while setting this up and wrote down as notes. Always read the error messages and hopefully some searches for them will provide workarounds or solutions if you have problems setting up this project.

Have you tried using verbose mode? If you check the provisioning block in the `Vagrantfile` there's an `ansible.verbose = "v"` line commented out. Try uncommenting it and hopefully it'll help you with more detail into what's happening.

If you're running ansible manually you can add `-v` switches to get verbose output. 

### I can't run ansible because ssh hosts can't be added to the approved list?!?!
Are you in the correct folder? Try setting the following to false, `ANSIBLE_HOST_KEY_CHECKING`, e.g. `ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ... ...`. Alternatively this is set in `ansible/ansible.cfg` but only used if running the command from that working directory.

### How do I create an inventory file when using vagrant?!?!
When you run `vagrant provision` an inventory is generated that you can reference. It is: `.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory`.
Use the `-i` flag to reference it, e.g. `ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory playbook.yml -b`.
