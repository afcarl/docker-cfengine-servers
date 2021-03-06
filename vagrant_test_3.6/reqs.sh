#!/bin/bash

################################################################################
# Copyright (c) 2014, 2015 Genome Research Ltd.
#
# Author: Matthew Rahtz <matthew.rahtz@sanger.ac.uk>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
################################################################################

# Installs requirements and buils Dockerfiles

set -o errexit

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
    36A1D7869245C8950F966E92D8576A8BA88D21E9
echo deb https://get.docker.com/ubuntu docker main \
    > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get -y install lxc-docker dhcpcd

docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter

cfengine_deb_url="http://s3.amazonaws.com"
cfengine_deb_url+="/cfengine.package-repos/community_binaries"
cfengine_deb_url+="/cfengine-community_3.6.4-1_amd64.deb"
wget -q "$cfengine_deb_url" -O /tmp/cfe.deb
dpkg -i /tmp/cfe.deb

# make a copy of the repository contents as it exists on the host
# otherwise, if both tests are running at once, they'll fight
# over SSH keys
cp -a /repo_host /repo

cd "/repo/dockerfiles"
./build_images.sh
