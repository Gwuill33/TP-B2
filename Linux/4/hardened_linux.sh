#!/bin/bash

# Linux Kernel Hardening

echo "Starting script"

dnf update -y

function check_chrony() {
    echo "Checking chrony"
    if rpm -q chrony; then
        echo "Chrony is installed"
    else
        echo "Chrony is not installed, installing..."
        yum install chrony -y
    fi
}

function check_chrony_conf() {
    echo "Checking Chrony configuration"
    if grep -E "^(server|pool)" /etc/chrony.conf; then
        echo "Chrony is configured"
    else
        echo "Chrony is not configured"
    fi
}

function check_ssh_config() {
    echo "Checking SSH configuration"
    if stat -Lc "%n %a %u/%U %g/%G" /etc/ssh/sshd_config | grep -q "/etc/ssh/sshd_config 600 0/root 0/root"; then
        echo "SSH is configured"
    else
        echo "Configuring SSH..."
        chown root:root /etc/ssh/sshd_config
        chmod 600 /etc/ssh/sshd_config
    fi
}

function install_aide() {
    echo "Checking Aide"
    if rpm -q aide; then
        echo "Aide is installed"
    else
        echo "Aide is not installed, installing..."
        yum install aide -y
    fi
}

function configure_aide() {
    echo "Configuring Aide"
    local aide_conf_file="/etc/aide.conf"
    
    if [ -e "$aide_conf_file" ]; then
        echo "Aide is configured"
    else
        echo "Creating Aide configuration file..."
        cat <<EOF >"$aide_conf_file"
# Aide Configuration File
/etc/ssh/sshd_config CONTENT_EX
/etc/chrony.conf CONTENT_EX
/etc/system/systemd CONTENT_EX
EOF

        echo "Creating Aide systemd service and timer..."
        cat <<EOF >/etc/systemd/system/aide.service
[Unit]
Description=Super service aide
[Service]
Type=simple
ExecStart=/usr/sbin/aide --check
EOF

        cat <<EOF >/etc/systemd/system/aide.timer
[Unit]
Description=Run Aide regularly

[Timer]
OnBootSec=0
OnUnitActiveSec=600

[Install]
WantedBy=timers.target
EOF

        systemctl enable --now aide.timer
    fi
}

function install_fail2ban() {
    echo "Checking Fail2ban"
    if rpm -q fail2ban; then
        echo "Fail2ban is installed"
    else
        echo "Fail2ban is not installed, installing..."
        dnf install epel-release -y
        dnf install fail2ban -y
    fi
}

function config_fail2ban() {
    echo "Configuring Fail2ban"
    
    if [ -e  ]; then
        echo "Fail2ban is configured"
    else
        echo "Creating Fail2ban configuration file for ssh..."
        cat <<EOF >/etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
maxretry = 3
bantime = 600
EOF

        echo "Creating Fail2ban configuration file for nginx..."
        cat <<EOF >/etc/fail2ban/jail.d/nginx.local
[nginx-http-auth]
enabled = true
port = http,https
logpath = %(nginx_error_log)s
bantime = 600
EOF

        systemctl enable --now fail2ban
        echo systemctl status fail2ban
    fi

}

function network_hardening() {
    echo "Network hardening"
    echo "Disabling IPv6"
    cat <<EOF >/etc/sysctl.conf
sysctl -w net.ipv6.conf.all.disable_ipv6 = 1
sysctl -w net.ipv6.conf.default.disable_ipv6 = 1
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.tcp_syncookies=1
EOF
    sysctl -p
}

function firewall_config() {
    echo "Configuring firewall"
    firwall-cmd --permanent --add-port=80/tcp
    firewall-cmd --remove-service=ssh --permanent
    firewall-cmd --remove-service=dhcpv6-client --permanent
    firewall-cmd --remove-service=cockpit --permanent
    firewall-cmd --add-port=22/tcp --permanent
    firewall-cmd --reload
    echo "Firewall configured"
}


check_chrony
check_chrony_conf
check_ssh_config
install_aide
configure_aide
install_fail2ban
config_fail2ban
network_hardening


echo "Script finished"