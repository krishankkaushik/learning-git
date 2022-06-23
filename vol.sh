#!/usr/bin/bash
growpart /dev/xvda "1"
xfs_growfs /dev/xvda1
#xfs_growfs /dev/xvdf1 /partition1
df -h

