ec2-metadata -i
echo "Enter the Instance ID below :"
read instance_id
echo "The volume attachments for this instance $instance_id and the current size of instances in this region  are shown below : "
#v=$(aws ec2 describe-volumes --query 'Volumes[].[Attachments[?InstanceId== `i-01a4c024b86666a4f`], VolumeId, Size]')
#a=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=i-01a4c024b86666a4f)
#w=$(jq -r '.[] | .[] | .VolumeId')
#echo "$a | $w"
b=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instance_id | jq -r '.[] | .[] | .VolumeId')
echo " the value of b is  $b"
aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instance_id | jq -r '.Volumes[] | .Attachments[]| .InstanceId, .VolumeId, .Device'
