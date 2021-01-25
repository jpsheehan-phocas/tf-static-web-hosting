# Terraform Static Web Hosting

Provisions cloud resources for static web hosting using:
- Amazon AWS S3 for file storage
- Cloudflare for DNS hosting

## Setting Up

1. First you will need to download and install [Terraform](https://www.terraform.io/downloads.html).

2. You will need to clone this repo:

    ```bash
    git clone https://github.com/jpsheehan-phocas/tf-static-web-hosting.git
    ```

3. You will need to initialise Terraform in the cloned directory:

    ```bash
    cd tf-static-web-hosting
    terraform init
    ```

4. You will need to have a domain name hosted at [Cloudflare](https://cloudflare.com). You'll need to [create an API token](https://dash.cloudflare.com/profile/api-tokens) with the "Zone.DNS:Edit" permission and include the zone that corresponds to your domain name. Then set the `CLOUDFLARE_API_TOKEN` shell environment variable to the token you get.

5. You will need to have an [Amazon AWS](https://aws.amazon.com/) account and set the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_DEFAULT_REGION` shell environment variables appropriately. Alternatively, [another authentication method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication) can be used. If creating a new role for this purpose make sure it has full permissions for S3.

6. Have some content you wish to upload! You should at least have a file named "index.html" (you could also have an "error.html" but this is optional).

## Running Terraform

Now that you have all the authentication taken care of you may now run Terraform.
You will need to specify a couple of variables:
- `domain`: the domain name you have registered with Cloudflare
- `subdomain`: the subdomain you wish to use (you can leave this one out and get a random one if you like)
- `folder`: the path to the folder you wish to upload to S3, this should contain your website

You can either set the default values of the variables in `vars.tf` or pass them in as arguments when you run the program:
```bash
terraform apply -var 'domain=foo.nz' -var 'folder=example' -var 'subdomain=tf-static-web-hosting'
```

If `terraform apply` completes successfully, it will output a few important values.
The most interesting is probably the `website_url` which is the link to your website!

## Destroying the Website

When you're done with your website, simply run `terraform destroy`.
Easy as!

## Known Issues

Websites created with this are HTTP only. If you want HTTPS websites you should be able to do that with [Amazon's CloudFront](https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html).

Websites cannot be updated with new content very easily, they need to be destroyed and applied entirely each time.

This is just a little learning exercise with Terraform, AWS, and Cloudflare :)