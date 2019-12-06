# Test it 
What behaviours do we care about? a.k.a. Tests that tell us what we should expect when doing specific things. What follows are some examples written in a [Given-When-Then](https://www.agilealliance.org/glossary/gwt/) format, these are only examples.

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
