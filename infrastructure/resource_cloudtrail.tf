resource "aws_cloudtrail" "website_object_log" {
  name                          = "ct-s3-${local.global_bucket_frontend}"
  s3_bucket_name                = var.global_bucket_logs
  include_global_service_events = false

  tags = {
    Environment = var.global_tag_environment
    Service     = var.global_tag_service
  }

  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = false

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.frontend.arn}/"]
    }
  }
}
