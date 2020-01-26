#!/bin/bash

sudo yum install httpd -y
sudo chkconfig httpd on
echo "<h1> Hello from $(hostname -f) </h1>" > /var/www/html/index.html
sudo service httpd start

