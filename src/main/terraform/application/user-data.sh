#!/bin/bash

echo 'http_proxy=http://${proxy_address}:${proxy_port}; export http_proxy' >> /etc/bashrc
echo 'https_proxy=https://${proxy_address}:${proxy_port}; export https_proxy' >> /etc/bashrc
echo 'no_proxy=169.254.169.254; export no_proxy' >> /etc/bashrc