terraform {
  cloud {
    organization = "lorenzoregaladohdez"
    hostname     = "app.terraform.io"
    workspaces {
      name = "prod"
    }
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_pages_project" "lorenzoregalado-com" {
  account_id        = var.cloudflare_account_id
  name              = "lorenzoregalado-com"
  production_branch = "master"
  build_config = {
    destination_dir = "public"
    root_dir        = "/"
    framework       = "hugo"
    build_command   = "hugo --gc --minify"
  }

  deployment_configs = {
    default = {
      env_vars = {
        "HUGO_VERSION" = {
          type  = "plain_text"
          value = "0.128.0"
        }
      }
    }
    production = {
      env_vars = {
        "HUGO_VERSION" = {
          type  = "plain_text"
          value = "0.128.0"
        }
      }
    }
  }
  source = {
    config = {
      deployments_enabled            = true
      owner                          = "lregaladohdez"
      production_branch              = "master"
      production_deployments_enabled = true
      repo_name                      = "lorenzoregalado.com"
    }
    type = "github"
  }
}

resource "cloudflare_pages_domain" "lorenzoregalado-com" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.lorenzoregalado-com.name
  name         = "lorenzoregalado.com"
}


resource "cloudflare_dns_record" "lorenzoregalado-blog" {
  name    = "blog.lorenzoregalado.com"
  type    = "CNAME"
  ttl     = 1
  content = "hashnode.network"
  proxied = true
  zone_id = "ff0df890eae549199f4de265c3290868"
}