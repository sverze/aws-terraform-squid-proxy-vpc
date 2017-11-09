#!/bin/bash

yum update -y
yum install -y squid

cat > /etc/squid/squid.conf << EOF
# Local network access to proxy
acl localnet src ${aws_private_vpc_cidr}
acl localnet src ${aws_public_vpc_cidr}

# Safe ports that can be used
acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 443		# https
acl Safe_ports port 1025-65535	# unregistered ports
acl CONNECT method CONNECT

# Destination domains that can be accessed
acl whitelist dstdomain sqs.us-east-1.amazonaws.com
acl whitelist dstdomain sqs.us-east-2.amazonaws.com
acl whitelist dstdomain sqs.us-west-1.amazonaws.com
acl whitelist dstdomain sqs.us-west-2.amazonaws.com
acl whitelist dstdomain www.amazonaws.com

# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports

# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager

# Localnet can access all domains in the whitelist
http_access allow localnet whitelist
http_access allow localhost

# And finally deny all other access to this proxy
http_access deny all

# Squid normally listens to port ${squid_port}
http_port 3128

# Uncomment and adjust the following to add a disk cache directory.
#cache_dir ufs /var/spool/squid 100 16 256

# Leave coredumps in the first cache dir
coredump_dir /var/spool/squid

# Add any of your own refresh_pattern entries above these.
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320

EOF

service squid start
chkconfig squid on
