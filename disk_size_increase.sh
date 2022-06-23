#!/bin/bash
echo "Enter the new size you want of the disk : "
read size
aws ec2 modify-volume --size $size --volume-id vol-0c178afe8eea79143
df -h
set GROWPART = "/dev/xvda 1"
growpart $GROWPART
set xfs_growfs = "/dev/xvda1"
xfs_growfs $xfs_growfs
df -h

