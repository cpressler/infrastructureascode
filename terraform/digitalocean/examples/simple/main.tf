variable do_token {}

provider digitalocean {
    token = var.do_token
}

data "digitalocean_ssh_key" "main" {
    name = "main"
}

data "digitalocean_ssh_key" "work" {
    name = "work"
}

resource "digitalocean_droplet" "web" {
    image = "ubuntu-18-04-x64"
    name = "sv-test1"
    region = "nyc3"
    size = "s-1vcpu-1gb"
    ssh_keys = [data.digitalocean_ssh_key.main.id, 
        data.digitalocean_ssh_key.work.id]
}

output "server_ip" {
    value = digitalocean_droplet.web.ipv4_address
}
