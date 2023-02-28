provider "aws" {
	region = "ap-south-1"
}

resource "aws_s3_bucket" "mybucket" {
	bucket = "training-terra"
	acl = "public-read"
	versioning {
		enabled = true
	}

	tags = {
		Name = "traininig-terra"
	}

	lifecycle_rule {
		id = "log"
		enabled = true
		prefix = "log/"
		tags = {
			"rule" = "log"
			"autoclean" = "true"
		}
		transition {
			days = 30
			storage_class = "STANDARD_IA"
		}
		transition {
			days = 60
			storage_class = "GLACIER"
		}
		expiration {
			days = 110
		}
	}
}
