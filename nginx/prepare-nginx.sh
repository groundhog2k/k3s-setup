#!/bin/bash
echo ">>>>> Preparing Nginx as reverse proxy"
## Prepare Nginx as local reverse proxy between localhost and WSL internal network
sudo apt update && sudo apt install nginx -y
sudo cp configs/nginx.conf /etc/nginx
sudo service nginx restart
echo "<<<<< Nginx ready."