output "s3_bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "s3_bucket_domain" {
  value = "http://${aws_s3_bucket.bucket.bucket_domain_name}"
}

output "cloudflare_record_id" {
  value = cloudflare_record.cname.id
}

output "website_url" {
  value = "http://${cloudflare_record.cname.hostname}/"
}
