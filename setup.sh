#!/bin/bash
sed -i 's/^#Port 22$/Port 2201/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin yes$/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#LoginGraceTime 2m$/LoginGraceTime 30s/' /etc/ssh/sshd_config
sed -i 's/^#MaxAuthTries 6$/MaxAuthTries 2/' /etc/ssh/sshd_config
systemctl restart ssh

cat >> /etc/sysctl.conf << EOF
net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = bbr
net.ipv4.icmp_echo_ignore_all = 1
EOF
sysctl -p

sed -i '/disable_ipv6/d' /etc/sysctl.{conf,d/*}
echo 'net.ipv6.conf.all.disable_ipv6 = 0' >/etc/sysctl.d/ipv6.conf
sysctl -w net.ipv6.conf.all.disable_ipv6=0

cat >> /etc/apt/sources.list << EOF
deb http://deb.debian.org/debian buster-backports main
EOF
apt update
apt -t buster-backports install linux-image-amd64
apt install sudo curl ufw git -y

ufw allow 22
ufw allow 2201
ufw allow 443
ufw allow 80

useradd -m Admin
usermod -s /bin/bash Admin
usermod -aG sudo Admin
echo "Passwd for Admin"
passwd Admin

useradd -m Yxwe
usermod -s /bin/bash Yxwe
echo "Passwd for Yxwe"
passwd Yxwe

sleep 6s
reboot
