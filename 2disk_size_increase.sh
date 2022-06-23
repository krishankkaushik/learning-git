#!/usr/bin/bash
#echo "The current disk size is : "
#df -h
#ec2-metadata -i
#echo "Enter the Instance ID below :"
#read instance_id
#echo "Choose the volume you want to increase and then enter the VolumeId below : "
#aws ec2 describe-volumes --query 'Volumes[*].InstanceId.VolumeId.Device.Size'
#echo "Enter the Volume ID below :"
#read volume_id
#echo "Enter the new size (only in numbers) you want below: "
#read size
#aws ec2 modify-volume --size $size --volume-id vol-0c201efa9afd38a5f         # $volume_id can be used in other case
#df -h
#growpart /dev/xvda "1"
#xfs_growfs /dev/xvda1
#df -h

echo "The current disk size is : "
df -h
ec2-metadata -i
echo "Enter the Instance ID below :"
read instance_id
echo "The volume attachments for this instance $instance_id are shown below : "
aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[].Instances[].RootDeviceName" --output text 
`a=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[].Instances[].RootDeviceName" --output text)` 
aws ec2 describe-volumes  --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.device,Values=/dev/xvda --query 'Volumes[*].VolumeId' --output text
#aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.device,Values=/dev/xvda | jq -r '.Volumes[] | .Attachments[]| .InstanceId, .VolumeId, .Device'
set volume_id=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.device,Values=/dev/xvda --query 'Volumes[*].VolumeId' --output text)
echo "Enter the New Size (only in numbers) you want below: "
read size
aws ec2 modify-volume --size $size --volume-id $volume_id         # $volume_id can be used in other case
sleep 3
df -h
#growpart $a "1"
#xfs_growfs $a1
df -h

