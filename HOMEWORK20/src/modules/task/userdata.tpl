#!/bin/bash

sudo yum -y update
sudo yum install -y nginx

ip=`curl http://checkip.amazonaws.com`

cat <<EOF > /usr/share/nginx/html/index.html
<html>
%{ for word in words }
<h2>Welcome to ${word}</h2>
%{ endfor ~}
<font color="blue">Server Public IP: <font color="red">$ip<br><br>
</html>
EOF

sudo systemctl enable nginx
sudo systemctl start nginx
