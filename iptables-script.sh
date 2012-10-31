#!/bin/sh

# Vide les tables
iptables -t filter -F

# Vide les règles
iptables -t filter -X

# Interdit toutes connexions entrantes et sortantes
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP

### Regles de base

# Ne pas casser les connexions etablies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Autorise loopback
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT

# ICMP (Ping)
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT

### SSH

# SSH In
iptables -t filter -A INPUT -p tcp --dport 2222 -j ACCEPT

# SSH Out
iptables -t filter -A OUTPUT -p tcp --dport 2222 -j ACCEPT

### DNS

# DNS In/Out
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT


### NTP

# NTP Out
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT


### Si serveur WEB

# HTTP + HTTPS Out
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT

# HTTP + HTTPS In
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT



### Si serveur FTP

# FTP Out
iptables -t filter -A OUTPUT -p tcp --dport 20:21 -j ACCEPT

# FTP In
# Active le module conntrack
modprobe ip_conntrack_ft
iptables -t filter -A INPUT -p tcp --dport 20:21 -j ACCEPT
iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT



### Si serveur MAIL

# Mail SMTP (port 25)
iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT

# Mail POP3 (port 110)
iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT

# Mail IMAP (port 143)
iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT

# Mail POP3S (port 995 pour POP3 SSL)
iptables -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT



### Accès aux disques via le réseau (iSCSI)
iptables -A OUTPUT -p tcp --dport 3260 -m state --state NEW,ESTABLISHED -j ACCEPT
