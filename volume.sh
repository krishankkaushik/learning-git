echo "The current disk size is : "
df -h
ec2-metadata -i
echo "Enter the Instance ID below : "
read instance_id
echo "Choose the volume you want to increase and then enter the VolumeId below : "
#aws ec2 describe-volumes --query 'Volumes[*].Attachments[?Device==`/dev/xvda`].VolumeId'
#aws ec2 describe-volumes --query 'Volumes[*].Attachments[?Device==`/dev/sdf`].VolumeId'
aws ec2 describe-volumes --query 'Volumes[*].Attachments[?InstanceId==`i-01a4c024b86666a4f`].VolumeId'

#if [$volume == $root]
#then
#       aws ec2 describe-volumes --query 'Volumes[*].Attachments[?Device==`/dev/xvda`].VolumeId'
#elif [$volume == $non_root]
#then
#       aws ec2 describe-volumes --query 'Volumes[*].Attachments[??Device==`/dev/sdf`].VolumeId'
#else
#       echo "No such volume found"
#fi
#set MY_root_vol = aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.delete-on-termination,Values=true
#vi volume.sh
#echo "$MY_root_vol" >> volume.sh

#if ./volume.sh | grep -q 'VolumeId'; then
#  echo "matched"

#set MY_non-root_vol = aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.delete-on-termination,Values=false
#echo
echo "Enter the Volume ID below :"
read volume_id
echo "Enter the new size you want of the disk below: "
read size
aws ec2 modify-volume --size $size --volume-id $volume_id
df -h
growpart /dev/xvda "1"
xfs_growfs /dev/xvda1
#xfs_growfs /dev/xvdf1 /partition1
df - h
sh vol.sh
#growpart /dev/xvda "1"
#xfs_growfs /dev/xvda1
#xfs_growfs /dev/xvdf1 /partition1
#df -h

