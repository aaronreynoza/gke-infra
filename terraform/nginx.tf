module "nginx-controller" {
  source  = "terraform-iaac/nginx-controller/helm"
  version = "2.0.4"
  ip_address = google_compute_address.ingress_ip_address.address
}

resource "google_compute_address" "ingress_ip_address" {
  name = "nginx-controller"
}
