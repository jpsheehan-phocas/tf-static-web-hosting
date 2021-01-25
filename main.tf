terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.17.0"
    }
  }
}

provider "cloudflare" {
  # you may place configuration options here
}

provider "aws" {
  # you may place configuration options here
}

locals {
  subdomain = var.subdomain == "" ? uuid() : var.subdomain
  fqdn      = "${local.subdomain}.${var.domain}"
}

resource "aws_s3_bucket" "bucket" {
  # our bucket must have the same name as the intended FQDN
  bucket = local.fqdn

  # make our website publicly readable
  acl = "public-read"

  # our bucket policy needs to reference the FQDN of our website
  policy = templatefile("policy.json", { fqdn = local.fqdn })

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

# create an s3 bucket object for every file in var.folder
resource "aws_s3_bucket_object" "index" {

  for_each = fileset(var.folder, "**")

  # specify our bucket
  bucket = aws_s3_bucket.bucket.bucket

  # make the file publicly readable
  acl = "public-read"

  # the filename to save in the bucket
  key = each.value

  # the location of the file on disk
  source = "${var.folder}/${each.value}"

  # this may not be correct, but it works
  content_type = "text/html"

  # used for versioning and updates
  etag = filemd5("${var.folder}/${each.value}")
}

data "cloudflare_zones" "zone" {
  filter {
    name = var.domain
  }
}

resource "cloudflare_record" "cname" {

  # lookup the zone of the cloudflare domain
  zone_id = lookup(data.cloudflare_zones.zone.zones[0], "id")

  # the subdomain of our website
  name = local.subdomain

  # we are setting up a CNAME record
  type = "CNAME"

  # we want to point it to the endpoint specified by the bucket
  value = aws_s3_bucket.bucket.website_endpoint
}
