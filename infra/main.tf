data "openstack_compute_flavor_v2" "math26" {
  name = "g4.cores8.ram16.disk20"
}

data "openstack_images_image_v2" "trixie" {
  name        = "debian-13.0-trixie"
  most_recent = true
}

data "openstack_networking_network_v2" "dualstack" {
  name = "VXLAN/IPv6-dualstack"
}

resource "openstack_compute_instance_v2" "math26" {
  name            = "math26"
  image_id        = data.openstack_images_image_v2.trixie.id
  flavor_id       = data.openstack_compute_flavor_v2.math26.id
  security_groups = ["default", "MathPublicIp"]

  network {
    uuid = data.openstack_networking_network_v2.dualstack.id
  }

  lifecycle {
    # Images are replaced regularly; don't rebuild the instance for that.
    ignore_changes = [image_id]
  }
}

# Mounted on /srv by deploy.
resource "openstack_blockstorage_volume_v3" "math26" {
  name = "math26"
  size = 90
}

resource "openstack_compute_volume_attach_v2" "math26" {
  instance_id = openstack_compute_instance_v2.math26.id
  volume_id   = openstack_blockstorage_volume_v3.math26.id
}

# Deleting an instance also deletes its prefix, asynchronously; create it only after the instance.
resource "cloudvps_puppet_prefix" "math26" {
  depends_on = [openstack_compute_instance_v2.math26]
  name       = "math26.math.eqiad1.wikimedia.cloud"
  roles      = ["profile::docker::engine"]
  hiera = yamlencode({
    "profile::docker::engine::settings" : {
      "data-root" : "/srv/docker",
      "log-driver" : "local",
    }
  })
}

# The project has a single floating IP; all math.wmflabs.org names point to it.
data "openstack_networking_floatingip_v2" "public" {
  tenant_id = "math"
}

data "openstack_networking_port_v2" "math26" {
  device_id  = openstack_compute_instance_v2.math26.id
  network_id = data.openstack_networking_network_v2.dualstack.id
}

resource "openstack_networking_floatingip_associate_v2" "public" {
  floating_ip = data.openstack_networking_floatingip_v2.public.address
  port_id     = data.openstack_networking_port_v2.math26.id
}

output "math26_ip" {
  value = openstack_compute_instance_v2.math26.access_ip_v4
}
