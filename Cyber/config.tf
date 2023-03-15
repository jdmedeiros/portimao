data "template_file" "desktop" {
  template = <<EOF
#!/bin/bash
hostnamectl set-hostname desktop
apt-get update
apt-get upgrade
apt install -y xfce4 xfce4-goodies
apt install -y xrdp filezilla
install mysql-workbench-community
snap connect mysql-workbench-community:password-manager-service :password-manager-service
snap install brave
snap install thunderbird
adduser xrdp ssl-cert
echo -e "ubuntu\nPassw0rd" | passwd ubuntu
echo xfce4-session > /home/ubuntu/.xsession
chown ubuntu:ubuntu /home/ubuntu/.xsession
sudo systemctl enable --now xrdp

EOF
}
