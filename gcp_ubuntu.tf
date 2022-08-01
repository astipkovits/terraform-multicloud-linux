#Google cloud
#---------------------------------

resource "google_compute_instance" "vm_instance" {
  count = var.cloud == "gcp" ? 1 :0 
  name         = var.name  
  machine_type = var.size
  zone         = var.region
  tags         = []

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id

    #Omitting the access config allows for the creation of the instance without public IP
    #access_config {
    #  nat_ip = google_compute_address.instance1_ip.address
    #}
  }
}