#Oracle cloud
#---------------------------------

/*
resource "oci_core_instance" "ubuntu_instance" {
    count = var.cloud == "oci" ? 1 :0 
    # Required
    availability_domain = var.oci_ad_name
    compartment_id = var.oci_compartment_id
    shape = var.size
    source_details {
        source_id = "<source-ocid>"
        source_type = "image"
    }

    # Optional
    display_name = var.name
    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
    metadata = {
        ssh_authorized_keys = file("<ssh-public-key-path>")
    } 
    preserve_boot_volume = false
}
*/