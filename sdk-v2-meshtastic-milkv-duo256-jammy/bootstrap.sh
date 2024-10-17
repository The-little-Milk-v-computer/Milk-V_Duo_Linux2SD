#!/bin/bash

/debootstrap/debootstrap --second-stage

# Update sources
cat >/etc/apt/sources.list <<EOF
deb $BASE_URL $DISTRO main restricted

deb $BASE_URL $DISTRO-updates main restricted

deb $BASE_URL $DISTRO universe
deb $BASE_URL $DISTRO-updates universe

deb $BASE_URL $DISTRO multiverse
deb $BASE_URL $DISTRO-updates multiverse

deb $BASE_URL $DISTRO-backports main restricted universe multiverse

deb $BASE_URL $DISTRO-security main restricted
deb $BASE_URL $DISTRO-security universe
deb $BASE_URL $DISTRO-security multiverse
EOF


# update and install some packages
apt update
apt install --no-install-recommends -y util-linux haveged openssh-server systemd kmod \
                                       initramfs-tools conntrack ebtables ethtool iproute2 \
                                       iptables mount socat ifupdown iputils-ping vim dhcpcd5 \
                                       neofetch sudo chrony wget net-tools joe less \
                                       libx11-dev

# optional zram
apt install -y zram-config
systemctl enable zram-config


apt install -y -q libgpiod-dev libyaml-cpp-dev libbluetooth-dev gpiod \
                  python3-full virtualenv git libssl-dev libsdl2-dev \
                  libulfius-dev nano neofetch avahi-daemon wget bluez \
                  btop htop libinput-dev libxkbcommon-dev libgpiod2


dd if=/dev/zero bs=1M of=swapfile count=192 status=progress;chmod 0600 swapfile;mkswap -f swapfile;

# Create base config files
mkdir -p /etc/network
cat >>/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto end0
iface end0 inet dhcp

EOF

cat >/etc/resolv.conf <<EOF
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

cat >/etc/fstab <<EOF
# <file system>	<mount pt>	<type>	<options>	<dump>	<pass>
/dev/root	/		ext2	rw,noauto	0	1
proc		/proc		proc	defaults	0	0
devpts		/dev/pts	devpts	defaults,gid=5,mode=620,ptmxmode=0666	0	0
tmpfs		/dev/shm	tmpfs	mode=0777	0	0
tmpfs		/tmp		tmpfs	mode=1777	0	0
tmpfs		/run		tmpfs	mode=0755,nosuid,nodev,size=64M	0	0
sysfs		/sys		sysfs	defaults	0	0
/swapfile       none            swap    sw              0       0
EOF

# set hostname
echo "meshtastic" > /etc/hostname

# enable root login through ssh
sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

# set root passwd
echo "root:$ROOTPW" | chpasswd
