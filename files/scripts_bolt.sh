#!/bin/bash

set -e

sudo apt-get update
sudo apt-get install -y wget
wget https://apt.puppet.com/puppet-tools-release-xenial.deb
sudo dpkg -i puppet-tools-release-xenial.deb
sudo apt-get update
sudo apt-get install -y puppet-bolt=1.49.0-1xenial

mkdir -p ~/.puppetlabs/bolt/

cat << EOF > ~/.puppetlabs/bolt/bolt.yaml
modulepath: "~/.puppetlabs/bolt-code/modules:~/.puppetlabs/bolt-code/site-modules"
inventoryfile: "~/.puppetlabs/bolt/inventory.yaml"
concurrency: 10
format: human
ssh:
    host-key-check: false
    user: centos
    private-key: ~/.ssh/priv_key
EOF

cat << EOF > ~/.puppetlabs/bolt/inventory.yaml
---
config:
    ssh:
        host-key-check: false
        user: centos
        private-key: ~/.ssh/priv_key
EOF

cat << EOF > ~/.puppetlabs/bolt/Puppetfile
# Modules from the Puppet Forge.
mod 'danieldreier/autosign'
mod 'puppetlabs/puppet_agent'
EOF

bolt puppetfile install