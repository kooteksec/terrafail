
# ---------------------------------------------------------------------
# CloudTrail
# ---------------------------------------------------------------------
resource "aws_cloudtrail" "sac_cloudtrail" {
  name                          = "sac_cloudtrail"
  s3_bucket_name                = aws_s3_bucket.sac_testing.id
  enable_log_file_validation = true
  is_multi_region_trail = false
}

