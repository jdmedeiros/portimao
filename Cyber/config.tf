data "template_file" "desktop" {
  template = <<EOF
#!/bin/bash
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
apt -y install iptables-persistent netfilter-persistent
iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
netfilter-persistent save

hostnamectl set-hostname desktop
apt-get update
apt-get upgrade
#apt install -y xfce4 xfce4-goodies
apt install -y xrdp filezilla
snap install brave
snap install thunderbird
adduser xrdp ssl-cert
#echo xfce4-session > /home/ubuntu/.xsession
#chown ubuntu:ubuntu /home/ubuntu/.xsession
systemctl enable --now xrdp
EOF
}

data "template_file" "onion" {
  template = <<EOF
#!/bin/bash
LOGFILE="/var/log/cloud-config-"$(date +%s)
SCRIPT_LOG_DETAIL="$LOGFILE"_$(basename "$0").log

# Reference: https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>$SCRIPT_LOG_DETAIL 2>&1

cat <<'EOF' > /tmp/50-cloud-init.yaml.patch
--- 50-cloud-init.yaml_bak      2023-03-16 22:45:13.413033827 +0000
+++ 50-cloud-init.yaml  2023-03-16 22:44:13.691770064 +0000
@@ -7,6 +7,10 @@
     ethernets:
         ens5:
             dhcp4: true
+            routes:
+              - to: 0.0.0.0/0
+                via: 10.0.1.10
+                on-link: true
             dhcp4-overrides:
                 route-metric: 100
             dhcp6: false
EOF

patch /etc/netplan/50-cloud-init.yaml < /tmp/50-cloud-init.yaml.patch
netplan apply
wget https://raw.githubusercontent.com/jdmedeiros/portimao/main/Cyber/50-cloud-init.yaml.patch

hostnamectl set-hostname onion
apt update && apt -y update && apt -y install git build-essential
apt install -y xfce4 xfce4-goodies
apt install -y xrdp filezilla
apt install -y mysql-workbench-community
snap install brave
adduser xrdp ssl-cert
echo xfce4-session > /home/ubuntu/.xsession
chown ubuntu:ubuntu /home/ubuntu/.xsession
systemctl enable --now xrdp
EOF
}