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
    default = "s-2vcpu-4gb"
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

resource "digitalocean_droplet" "monitor" {
    image = var.droplet_image
    count = var.droplet_count
#    name = "sv-test-${var.region}-${count.index +1}"
    name = "monitor-${count.index +1}"
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
#    private_key = "${file(var.pvt_key)}"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo nohup yum -y update &",
      "sudo nohup yum -y install epel-release &",
      "sudo groupadd --system ansible",
      "sudo useradd -s /sbin/nologin --system -g ansible svc_ansible",
      #"sudo mkdir /home/svc_ansible/.ssh",
      "sudo cp -R /root/.ssh /home/svc_ansible/",
      "sudo chown svc_ansible:ansible /home/svc_ansible/"
    ]
  }


}


output "server_ip" {
    value = digitalocean_droplet.monitor.*.ipv4_address
}

output "server_name" {
    value = digitalocean_droplet.monitor.*.name
}


resource "digitalocean_record" "web" {
  count = var.droplet_count
  domain = data.digitalocean_domain.web.name
  type   = "A"
  ttl    = 30
  name   = digitalocean_droplet.monitor[count.index].name
  value   = digitalocean_droplet.monitor[count.index].ipv4_address
}

resource "digitalocean_record" "prometheus" {
  count = var.droplet_count
  domain = data.digitalocean_domain.web.name
  type   = "CNAME"
  ttl    = 30
  name   = "prometheus-${count.index +1}"
  value   = "${digitalocean_droplet.monitor[count.index].name}.${data.digitalocean_domain.web.name}."
}

resource "digitalocean_record" "grafana" {
  count = var.droplet_count
  domain = data.digitalocean_domain.web.name
  type   = "CNAME"
  ttl    = 30
  name   = "grafana-${count.index +1}"
  value   = "${digitalocean_droplet.monitor[count.index].name}.${data.digitalocean_domain.web.name}."
}

resource "digitalocean_record" "kibana" {
  count = var.droplet_count
  domain = data.digitalocean_domain.web.name
  type   = "CNAME"
  ttl    = 30
  name   = "kibana-${count.index +1}"
  value   = "${digitalocean_droplet.monitor[count.index].name}.${data.digitalocean_domain.web.name}."
}

resource "digitalocean_record" "elasticsearch" {
  count = var.droplet_count
  domain = data.digitalocean_domain.web.name
  type   = "CNAME"
  ttl    = 30
  name   = "elasticsearch-${count.index +1}"
  value   = "${digitalocean_droplet.monitor[count.index].name}.${data.digitalocean_domain.web.name}."
}

resource "digitalocean_record" "zipkin" {
  count = var.droplet_count
  domain = data.digitalocean_domain.web.name
  type   = "CNAME"
  ttl    = 30
  name   = "zipkin-${count.index +1}"
  value   = "${digitalocean_droplet.monitor[count.index].name}.${data.digitalocean_domain.web.name}."
}




