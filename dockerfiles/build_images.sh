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

rm -f container_ssh_key
ssh-keygen -N "" -f container_ssh_key
cp container_ssh_key.pub cfengine_3.1/
cp container_ssh_key.pub cfengine_3.6/
rm container_ssh_key.pub

# remove old images
for name in sanger/cf{3,36}testsrv; do
    if docker images | grep -q "$name"; then
        docker rmi -f "$name"
    fi
done

docker build -t 'mrahtz/cfe31srv' cfengine_3.1
docker build -t 'mrahtz/cfe36srv' cfengine_3.6
