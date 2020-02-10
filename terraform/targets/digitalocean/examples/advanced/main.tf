variable do_token {}

provider digitalocean {
    token = var.do_token
}

variable "region" {
    type    = string
    default = "nyc3"
}

variable "droplet_count" {
    type = number
    default = 1
}

variable "droplet_size" {
    type = string
    default = "s-1vcpu-1gb"
}


data "digitalocean_ssh_key" "main" {
    name = "main"
}

data "digitalocean_ssh_key" "work" {
    name = "work"
}

data "digitalocean_domain" "web" {
    name = "softvision.site"
}

resource "digitalocean_droplet" "webub" {
    image = "ubuntu-18-04-x64"
    count = var.droplet_count
#    name = "sv-test-${var.region}-${count.index +1}"
    name = "sv-test-${count.index +1}"
    region =  var.region
    size =  var.droplet_size
    ssh_keys = [data.digitalocean_ssh_key.main.id, 
        data.digitalocean_ssh_key.work.id]
# ensures that we create the new resource before we destroy the old one

    # https://www.terraform.io/docs/configuration resources.html#lifecycle-lifecycle-customizations
    lifecycle {
        create_before_destroy = true
    }
}


output "server_ip" {
    value = digitalocean_droplet.webub.*.ipv4_address
}

output "server_name" {
    value = digitalocean_droplet.webub.*.name
}


resource "digitalocean_record" "web" {
  count = var.droplet_count
  domain = data.digitalocean_domain.web.name
  type   = "A"
  ttl    = 30
  name   = digitalocean_droplet.webub[count.index].name
  value   = digitalocean_droplet.webub[count.index].ipv4_address
}

