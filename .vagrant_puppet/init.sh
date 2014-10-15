#!/bin/bash

create_modules_symlink () {
  ln -sfn /vagrant/spec/fixtures/modules /etc/puppet/modules
}

create_default_hiera_file() {
cat <<EOF > /etc/puppet/hiera.yaml
---
:backends: yaml
:yaml:
  :datadir: /var/lib/hiera
:hierarchy: common
:logger: console
EOF
}

STAGE='/tmp/doozer-vagrant-stage'

if [ ! -e $STAGE ]; then

  echo "Initial provision, running the doozer-vagrant shell provisioner script..."

  # update system apt cache
  apt-get update

  if [ ! -d '/etc/puppet' ]; then
    mkdir /etc/puppet
    chmod 755 /etc/puppet
  fi

  if [ -d '/etc/puppet/modules' ]; then
    mv /etc/puppet/modules /etc/puppet/modules.orig
  fi

  create_modules_symlink
  create_default_hiera_file

  touch $STAGE

else
  echo "Not initial provision, skipping the doozer-vagrant shell provisioner script..."
fi

exit 0
