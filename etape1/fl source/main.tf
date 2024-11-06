provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "my_network" {
  name = "my_network"
}

resource "docker_container" "http_server" {
  name    = "http_server"
  image   = "nginx:latest"
  ports {
    internal = 80
    external = 8080
  }
  networks_advanced {
    name = docker_network.my_network.name
  }
  volumes {
    container_path = "/usr/share/nginx/html"
    host_path      = "${path.module}/app"
  }
}

resource "docker_container" "php_fpm" {
  name    = "php_fpm"
  image   = "php:fpm"
  networks_advanced {
    name = docker_network.my_network.name
  }
  volumes {
    container_path = "/app"
    host_path      = "${path.module}/app"
  }
}
