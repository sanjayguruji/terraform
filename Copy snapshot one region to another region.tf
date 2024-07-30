provider "aws" {
  region = "ap-southeast-1" #destination Region

  
  resource "aws_ebs_volume" "data_vol" {
  availability_zone = "us-west-2a"
  size              = 40

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_ebs_snapshot" "data_vol_snapshot" {
  volume_id = aws_ebs_volume.data_vol.id

  tags = {
    Name = "HelloWorld_snap"
  }
}

resource "aws_ebs_snapshot_copy" "data_vol_snap_copy" {
  source_snapshot_id = aws_ebs_snapshot.data_vol_snapshot.id
  source_region      = "us-west-2"  #source Region of snapshot 

  tags = {
    Name = "HelloWorld_copy_snap"
  }
}
