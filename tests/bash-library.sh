#!/bin/bash

# Collection of functions used to to run tests for this helloworld project

# Table of Contents
# - syntax_ok : checks files are valid yaml and ready for ansible
# - http_200_ok : checks for 200 HTTP responses
# - loadbalancing_ok : checks for different key words from webservers
# - clean_up : destroy's vagrant boxes and deletes related files

syntax_ok () {
  # Pass through a path regex for files to be checked
  # SUCCESS = --syntax-check returns true, i.e. exit code 0
  echo "⏳ ... Starting ansible syntax checks ..."
  for file in $1; do
    if ! ansible-playbook "$file" --syntax-check 2> /dev/null; then
      echo "🚫 FAILED."
      echo "💔 Use:'ansible-playbook $file --syntax-check' to troubleshoot."
      exit
    fi
  done
  echo "✅ SUCCESS."
  echo "🏆 Ansible playbooks are ready for use."
}

http_200_ok () {
  # Pass through a URL to be checked
  # SUCCESS = "HTTP/1.1 200 OK" in the response
  echo "⏳ ... Starting webserver HTTP response check ..."
  if ! curl -s -I "$1" | grep "HTTP/1.1 200 OK"; then
    echo "🚫 FAILED."
    echo "💔 Not a 200 response. $(curl -s -I "$1" | grep "HTTP")"
    exit
  fi
  echo "✅ SUCCESS."
  echo "🏆 Host '$1' responds with 200 OK."
}

loadbalancing_ok () {
  # Pass through the inventory host name to be checked
  # SUCCESS = evidence of loadbalancing
  # Limited to content differences between pages, i.e. does string exist
  echo "⏳ ... Starting loadbalancer check ..."
  web1_count=0
  web2_count=0
  for i in {1..10}; do
    response=$(curl -s "$1")
    case $response in
      *"webserver-1"*)
        (( web1_count++ ))
        echo "🕸️ ... check $i hit webserver-1"
      ;;
      *"webserver-2"*)
        (( web2_count++ ))
        echo "🕸️ ... check $i hit webserver-2"
      ;;
    esac
  done
  echo "🎯 x $web1_count for webserver-1"
  echo "🎯 x $web2_count for webserver-2"
  if [ $web1_count == 0 ] || [ $web2_count == 0 ]; then
    echo "🚫 FAILED."
    echo "💔 One or both webservers are down."
    exit
  else
    echo "✅ SUCCESS."
    echo "🏆 The loadbalancer has responses from both 'webserver-1' and 'webserver-2'."
  fi
}

clean_up () {
  # Destructive : deletes files from the workspace
  echo "🗑️ ... Cleaning up temporary project files ... "
  echo "🗑️ ... Destroying vms ... "
  vagrant destroy -f
  echo "🗑️ ... Deleting files ... "
  rm -rf .vagrant ubuntu-bionic-18.04-cloudimg-console.log
}
