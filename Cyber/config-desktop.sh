#!/bin/bash -x
  if [ "$1" = "run" ]; then
  LOGFILE="/var/log/cloud-config-"$(date +%s)
  SCRIPT_LOG_DETAIL="$LOGFILE"_$(basename "$0").log

  # Reference: https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>$SCRIPT_LOG_DETAIL 2>&1

  sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
  sysctl -p

  echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
  echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
  apt-get -y install iptables-persistent netfilter-persistent
  iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
  iptables -A PREROUTING -i ens5 -p tcp --dport 3390 -j DNAT --to-destination 10.0.1.11:3389
  netfilter-persistent save

  hostnamectl set-hostname desktop
  apt-get update && apt -y upgrade
  apt-get install -y xfce4 xfce4-goodies
  apt-get  install -y xrdp filezilla chromium-browser
  snap install thunderbird
  adduser xrdp ssl-cert
  echo xfce4-session > /home/ubuntu/.xsession
  chown ubuntu:ubuntu /home/ubuntu/.xsession
  systemctl enable --now xrdp

fi
