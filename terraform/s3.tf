resource "aws_s3_bucket" "source" {
  bucket_prefix = "${var.project_name}-source-"
  force_destroy = true
  tags = {
    Name        = "${var.project_name}-source"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "output" {
  bucket_prefix = "${var.project_name}-output-"
  force_destroy = true
  tags = {
    Name        = "${var.project_name}-output"
    Environment = "dev"
  }
}