# Summary 
What behaviours do we care about? a.k.a. Tests that tell us what we should expect when doing specific things.

This folder contains content to help determine if the project is ok. How do we know it "looks good"?

# Use it
The automated tests are run as part of the automation, triggered with the `go_button.sh`. It's possible to run that again and again. The tests will also run again and again. Read through both the `go_button.sh` and the `bash-library.sh` files to see what they do.

For reference the `bash-library.sh` contains the helper and test functions used in the automation. This includes a linter (syntax check), a couple of http checks (using cURL) and a workspace cleaner (deletes files). If the project got bigger these could be logically split into different files.

This list of function names was generated using `grep "()" bash-library.sh`.
1. syntax_ok () {
1. http_200_ok () {
1. loadbalancing_ok () {
1. clean_up () {

For details on how these work, please read the code comments.

## Further examples
What follows are some examples written in a [Given-When-Then](https://www.agilealliance.org/glossary/gwt/) format. They're unrefined and weren't specifically used to write the `bash-library.sh` but the format can help inform choices on the "what and how" of testing system behaviour.

### Page Content
**Given** a user accesses the website on http://localhost:8080

 **and** uses cURL or a web browser

**Then** they get served a "Hello World" page

### Load Balancer
**Given** traffic goes through a load balancer

 **and** HTTP requests are balanced using round-robin

**Then** the page will be served by alternating webservers

### HTTP Health Check
**Given** we have two web servers behind a load balancer

**When** we send them HTTP requests avoiding the loadbalancer

**Then** we get a 200 response from both

### Config management
**Given** we use ansible to ensure configuration is applied

**When** running ansible-playbooks repeatedly

**Then** changes are successfully applied without error

### VM Spec
**Given** that we expect a particular base image to be used when creating the virtual machines

**When** we run `vagrant up`

**Then** the expected base image is used
