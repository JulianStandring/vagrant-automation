#!/bin/bash

# Pipeline script for bringing up and testing a project

# Load test and helper functions
. ./tests/bash-library.sh

# Splash info
echo "🚨 Automated create and test. Be prepared to wait. 🚨"
echo "🚨 Use '--destroy' to clean up. 🚨"
echo "📌 Balloons at the end mean everything worked. 🎈🎈"

# Check for "--destroy" and clean up if set
if [ "$1" == "--destroy" ]; then clean=true; else clean=false; fi
if $clean; then clean_up; fi

# Check the syntax on ansible files
syntax_ok "./ansible/*.yml"

# Start up the vms
echo "⏳ ... Starting vms with "vagrant up" ..."
vagrant up

# Check the website is responding
 http_200_ok "localhost:8080"

# Check the loadbalancer is operational
loadbalancing_ok "localhost:8080"

# The end and final clean up if "--destroy" is used
if $clean; then clean_up; fi
echo "🎈🎈🎈🎈🎈 the end 🎈🎈🎈🎈🎈"
echo "✅ SUCCESS. Here are more balloons... 🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈 ✅"
