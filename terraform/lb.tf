resource "google_compute_health_check" "default" {
  name = "reddit-app-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = "9292"
  }
}

resource "google_compute_instance_group" "reddit_app_servers" {
  name = "reddit-app-servers"

  instances = ["${google_compute_instance.app.*.self_link}"]

  named_port {
    name = "puma"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_backend_service" "reddit_app_backend" {
  name        = "reddit-app-backend"
  protocol    = "HTTP"
  port_name   = "puma"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group.reddit_app_servers.self_link}"
  }

  health_checks = ["${google_compute_health_check.default.self_link}"]
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "reddit-app-gfw-rule"
  target     = "${google_compute_target_http_proxy.default.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "default" {
  name    = "reddit-app-proxy"
  url_map = "${google_compute_url_map.default.self_link}"
}

resource "google_compute_url_map" "default" {
  name            = "reddit-app-url-map"
  default_service = "${google_compute_backend_service.reddit_app_backend.self_link}"
}

resource "google_compute_firewall" "lb" {
  name = "lb-firewall"

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]

  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  target_tags = ["reddit-app"]
}
