data "template_file" "install_ws" {
  template = "${file("${path.module}/templates/install_ws.ps1")}"

  vars {
    chef_workstation_dl_url  = "${var.chef_workstation_dl_url}",
    use_chocolatey           = "${var.workstation_use_chocolatey}",
    user                     = "${var.winrm_user}"
  }
}

resource "null_resource" "workstation_base_install" {
  count = "${length(var.workstation_ips)}"

  triggers {
    template = "${data.template_file.install_ws.rendered}"
  }

  connection {
    type     = "winrm"
    user     = "${var.winrm_user}"
    password = "${var.winrm_password}"
    host     = "${var.workstation_ips[count.index]}"
  }

  provisioner "file" {
    destination = "C:/install_ws.ps1"
    content     = "${data.template_file.install_ws.rendered}"
  }

  provisioner "remote-exec" {
    inline = [
      "powershell -ExecutionPolicy ByPass -File C:\\install_ws.ps1"
    ]
  }
}
