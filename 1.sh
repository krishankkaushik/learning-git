#!/usr/bin/bash
echo "The existing disk size is : "
df -h
ec2-metadata -i
echo "Enter the Instance ID below :"
read instance_id
#dev=`lsblk | grep disk`
#dev1=`lsblk| grep “part /“`
Dev_namE=$(/usr/bin/lsblk -oMOUNTPOINT,PKNAME -rn | /usr/bin/awk '$1 ~ /^\/$/ { print $2 }')
Dev_Name=$(/usr/bin/lsblk -l| grep "part /"| /usr/bin/awk '{print $1}')
d=$(date "+%R" -d "5 mins ago")             #to use the time 5 mins ago in "aws ec2 describe-volumes-modifications"
dev_name=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[].Instances[].RootDeviceName" --output text)
volume_id=$(aws ec2 describe-volumes  --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.device,Values=$dev_name --query 'Volumes[*].VolumeId' --output text)
SIZE=$(aws ec2 describe-volumes  --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.device,Values=$dev_name --query 'Volumes[*].Size' --output text)
echo "The volume attachments for this instance $instance_id are shown below : "
echo "$dev_name"
echo "$volume_id"
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
sleep 3
op=`aws ec2 describe-volumes-modifications --filters Name=volume-id,Values="$volume_id" --query "VolumesModifications[?StartTime>='$d'].{target_size: TargetSize}" --output text`
echo "Target size is : $op GB"
fi

#if [ $op -eq $size ]
#then
 #       echo "Volume modification SUCCESSFUL"
#else
#        echo "Volume modification FAILED"
#        exit 1
#fi


growpart /dev/$Dev_namE "1"
xfs_growfs /dev/$Dev_Name
sleep 10
df -h


