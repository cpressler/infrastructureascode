variable do_token {}
variable "pvt_key" { }
# type = string
#  default = "{$HOME}/.ssh/id_rsa"
#}

#variable "pub_key" {}



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

variable "droplet_image" {
  type = string
  default = "centos-7-x64"
}


data "digitalocean_ssh_key" "main" {
    name = "main"
}

data "digitalocean_ssh_key" "work" {
    name = "work"
}

data "digitalocean_ssh_key" "chrisb" {
  name = "chrisb"
}

data "digitalocean_domain" "web" {
    name = "softvision.site"
}

resource "digitalocean_droplet" "webub" {
    image = var.droplet_image
    count = var.droplet_count
#    name = "sv-test-${var.region}-${count.index +1}"
    name = "sv-test-${count.index +1}"
    region =  var.region
    size =  var.droplet_size
    private_networking = true
    ssh_keys = [data.digitalocean_ssh_key.main.id, 
        data.digitalocean_ssh_key.work.id, data.digitalocean_ssh_key.chrisb.id]
# ensures that we create the new resource before we destroy the old one

    # https://www.terraform.io/docs/configuration resources.html#lifecycle-lifecycle-customizations
    lifecycle {
        create_before_destroy = true
    }

  connection {
    user = "root"
    type = "ssh"
    host = self.ipv4_address
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      #"sudo yum update",
      #"sudo yum -y install epel-release",
      #"sudo yum -y install nginx",
      "sudo groupadd --system ansible",
      "sudo useradd -s /sbin/nologin --system -g ansible svc_ansible",
      #"sudo mkdir /home/svc_ansible/.ssh",
      "sudo cp -R /root/.ssh /home/svc_ansible/",
      "sudo chown svc_ansible:ansible /home/svc_ansible/"
    ]
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

resource "digitalocean_record" "consul" {
  count = var.droplet_count
  domain = data.digitalocean_domain.web.name
  type   = "CNAME"
  ttl    = 30
  name   = "consul-${count.index +1}"
  value   = "${digitalocean_droplet.webub[count.index].name}.${data.digitalocean_domain.web.name}."
}

