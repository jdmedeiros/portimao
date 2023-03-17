#!/bin/bash -x
if [ "$1" = "run" ]; then

  LOGFILE="/var/log/cloud-config-"$(date +%s)
  SCRIPT_LOG_DETAIL="$LOGFILE"_$(basename "$0").log

  # Reference: https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>$SCRIPT_LOG_DETAIL 2>&1

  patch /etc/netplan/50-cloud-init.yaml < /var/lib/cloud/instance/scripts/50-cloud-init.yaml.patch
  netplan apply
  hostnamectl set-hostname onion
  apt update && apt -y update && apt -y install git build-essential curl ethtool
  apt install -y xfce4 xfce4-goodies
  apt install -y xrdp filezilla
  snap install brave
  adduser xrdp ssl-cert
  echo xfce4-session > /home/ubuntu/.xsession
  chown ubuntu:ubuntu /home/ubuntu/.xsession
  systemctl enable --now xrdp

fi
