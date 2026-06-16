#!/bin/bash
aa-complain tcpdump
/etc/init.d/apparmor reload
tcpdump -i any net 10.8.0.0/16 -w /usr/local/node$1.cap
