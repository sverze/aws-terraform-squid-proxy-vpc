#!/bin/bash

yum update -y
yum install -y squid

echo 'acl whitelist dstdomain sqs.us-east-1.amazonaws.com' >> /etc/squid/squid.conf
echo 'acl whitelist dstdomain sqs.us-east-2.amazonaws.com' >> /etc/squid/squid.conf
echo 'acl whitelist dstdomain sqs.eu-west-1.amazonaws.com' >> /etc/squid/squid.conf
echo 'acl whitelist dstdomain sqs.eu-west-2.amazonaws.com' >> /etc/squid/squid.conf
echo 'acl whitelist dstdomain www.amazonaws.com' >> /etc/squid/squid.conf
echo 'http_access allow localnet whitelist' >> /etc/squid/squid.conf

service squid start
chkconfig squid on
