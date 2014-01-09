#!/bin/sh
mkdir -p $1/root/.ssh/
chmod 0700 $1/root/.ssh/
chmod 0700 $1/root
cp -p ~/.ssh/id_rsa.pub $1/root/.ssh/authorized_keys
chmod 0600 $1/root/.ssh/authorized_keys
