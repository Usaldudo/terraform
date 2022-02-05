#!/bin/bash
yum -y update
yum -y install httpd
myip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h2>WebServer with ip: $myip</h2><br>Build by Terraform using external script!" > /var/www/html/index.html
cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Terraform</h2><br>
Owner ${f_name}<br>
%{ for i in names ~}
Hello to ${i} from ${f_name}<br>
%{ endfor ~}

</html>
EOF

sudo service httpd start
chkconfig httpd on