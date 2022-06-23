#!/usr/bin/bash
echo "The existing disk size is : "
df -h
ec2-metadata -i
echo "Enter the Instance ID below :"
read instance_id
dev_name=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[].Instances[].RootDeviceName" --output text)
volume_id=$(aws ec2 describe-volumes  --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.device,Values=/dev/xvda --query 'Volumes[*].VolumeId' --output text)
SIZE=$(aws ec2 describe-volumes  --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.device,Values=/dev/xvda --query 'Volumes[*].Size' --output text)
echo "The volume attachments for this instance $instance_id are shown below : "
#aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instance_id | jq -r '.Volumes[] | .Attachments[]| .InstanceId, .VolumeId, .Device'
aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[].Instances[].RootDeviceName" --output text
aws ec2 describe-volumes  --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.device,Values=/dev/xvda --query 'Volumes[*].VolumeId' --output text
echo "Enter the New Size (only in numbers) you want below: "
read size
len=`echo -n $size | wc -c`
if [ $len -lt 1 ]
then
        echo "Please enter non-empty value "
        exit 1
elif [ $size -le $SIZE ]
then
	echo "You should enter value of New Size more than the existing size i.e $SIZE GB"
        exit 1
else
aws ec2 modify-volume --size $size --volume-id $volume_id
fi
sleep 3
df -h
growpart $dev_name "1"
xfs_growfs $dev_name"1"
df -h
growpart $dev_name "1"
xfs_growfs $dev_name"1"
lsblk
