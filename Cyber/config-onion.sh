#!/bin/bash -x
if [ "$1" = "run" ]; then

  LOGFILE="/var/log/cloud-config-"$(date +%s)
  SCRIPT_LOG_DETAIL="$LOGFILE"_$(basename "$0").log

  # Reference: https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>$SCRIPT_LOG_DETAIL 2>&1

  patch /etc/netplan/50-cloud-init.yaml < /var/lib/cloud/instance/scripts/50-cloud-init.yaml_1.patch
  netplan apply

  hostnamectl set-hostname onion
  apt-get update
  apt-get -y install git build-essential curl ethtool chromium-browser network-manager nfs-common xrdp filezilla
  #apt install -y xfce4 xfce4-goodies
  #echo xfce4-session > /home/ubuntu/.xsession
  #chown ubuntu:ubuntu /home/ubuntu/.xsession
  adduser xrdp ssl-cert
  systemctl enable --now xrdp

  mv /etc/netplan/50-cloud-init.yaml /etc/netplan/01-network-manager-all.yaml
  sudo touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
  patch /etc/netplan/01-network-manager-all.yaml < /var/lib/cloud/instance/scripts/50-cloud-init.yaml_2.patch
  systemctl enable --now NetworkManager
  netplan apply
  mkdir /mnt/efs
  /var/lib/cloud/instance/scripts/update-fstab.sh
  mount -a
  chgrp ubuntu /mnt/efs/
  chmod g+w /mnt/efs/

fi
