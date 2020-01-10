resource "oci_core_instance" "FoggyKitchenWebserver" {
  availability_domain = var.ADs[2]
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name = "FoggyKitchenWebServer1"
  shape = var.Shapes[0]
  subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
  source_details {
    source_type = "image"
    source_id   = var.Images[0]
  }
  metadata = {
      ssh_authorized_keys = file(var.public_key_oci)
      user_data = base64encode(file("./userdata/bootstrap"))
  }
  create_vnic_details {
     subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
     assign_public_ip = false
  }
}

data "oci_core_vnic_attachments" "FoggyKitchenWebserver_VNIC1_attach" {
  availability_domain = var.ADs[2]
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  instance_id = oci_core_instance.FoggyKitchenWebserver.id
}

data "oci_core_vnic" "FoggyKitchenWebserver_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.FoggyKitchenWebserver_VNIC1_attach.vnic_attachments.0.vnic_id
}

output "FoggyKitchenWebserver_PrivateIP" {
   value = [data.oci_core_vnic.FoggyKitchenWebserver_VNIC1.private_ip_address]
}

