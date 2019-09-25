sudo su <<EOF
yum update -y && yum upgrade -y
yum erase tcpdump
echo "AllowUsers ssm-user ec2-user lnag_*" >> /etc/ssh/sshd_config
echo "KexAlgorithms curve25519-sha256@libssh.org" >> /etc/ssh/sshd_config
echo "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr" >> /etc/ssh/sshd_config
echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com" >> /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config

sed -i -e "s/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g" /etc/ssh/sshd_config
sed -i -e "s/#LoginGraceTime 2m/LoginGraceTime 60/g" /etc/ssh/sshd_config
sed -i -e "s/#IgnoreRhosts yes/IgnoreRhosts yes/g" /etc/ssh/sshd_config
sed -i -e "s/#PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
sed -i -e "s/#PermitEmptyPasswords no/PermitEmptyPasswords no/g" /etc/ssh/sshd_config
sed -i -e "s/#PermitUserEnvironment no/PermitUserEnvironment no/g" /etc/ssh/sshd_config
sed -i -e "s/#HostbasedAuthentication no/HostbasedAuthentication no/g" /etc/ssh/sshd_config
sed -i -e "s/#X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config
sed -i -e "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config
sed -i -e "s/SELINUX=disabled/SELINUX=enforcing/g" /etc/ssh/sshd_config
sed -i -e "s/#MaxAuthTries 6/MaxAuthTries 4/g" /etc/ssh/sshd_config
EOF


cat <<EOF | sudo tee /etc/sysctl.d/01-tsi.conf
net.ipv4.icmp_echo_ignore_broadcasts = 1
kernel.randomize_va_space = 2
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
EOF

sudo su <<EOF
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.route.flush=1
sysctl -w kernel.randomize_va_space=2
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1

chown root:root /etc/crontab
chmod og-rwx /etc/crontab
chown root:root /etc/cron.d
chmod og-rwx /etc/cron.d
chown root:root /etc/cron.hourly
chmod og-rwx /etc/cron.hourly
chown root:root /boot/grub2/grub.cfg
chmod og-rwx /boot/grub2/grub.cfg
chown root:root /etc/cron.monthly
chmod og-rwx /etc/cron.monthly
chown root:root /etc/cron.daily
chmod og-rwx /etc/cron.daily
chown root:root /etc/cron.weekly
chmod og-rwx /etc/cron.weekly
find /var/log -type f -exec chmod g-wx,o-rwx {} +
EOF