resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket.frontend.website_endpoint
    origin_id   = aws_s3_bucket.frontend.bucket

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  logging_config {
    include_cookies = false
    bucket          = "${var.global_bucket_logs}.s3.amazonaws.com"
    prefix          = "CloudFront/"
  }

  aliases = ["www.${var.global_website_domain}", var.global_website_domain]

  //noinspection MissingProperty
  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = aws_s3_bucket.frontend.bucket
    compress                 = true
    cache_policy_id          = "a7fcdb8a-677e-47ba-9a05-8230fed77d83"
    origin_request_policy_id = "76b90ba9-bd24-4526-b4e3-e7a1730d9278"
    viewer_protocol_policy   = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.global_tag_environment
    Service     = var.global_tag_service
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.ssl.arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  wait_for_deployment = false
}
