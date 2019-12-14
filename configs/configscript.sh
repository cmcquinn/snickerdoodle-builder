#!/bin/bash

set -x
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C
/var/lib/dpkg/info/base-passwd.preinst install
/var/lib/dpkg/info/bash.preinst install
if [ -d /tmp/preseeds/ ]; then
        for file in `ls -1 /tmp/preseeds/*`; do
        debconf-set-selections $file
        done
fi
dpkg --configure -a
mount proc -t proc /proc
dpkg --configure -a
umount proc