#!/bin/bash
if [ "$UID" != "0" ] ; then
	echo "Sorry! You must be root to run this. Please use 'sudo' before the script name and try again."
	exit 2
fi
echo "Checking if Apache is installed..."
dpkg -L apache2 >/dev/null
if [ $? != "0" ] ; then
	echo "Apache2 not found! Installing now...."
	apt-get install apache2 -y
fi
echo "This script will help you to build a new virtual host file for Apache for any domain you enter"
echo "But first, please answer a few questions befroe we can continue:"
if [ -z "$domain" ] ; then
	read -p "What is your domain name? (i.e - example.com): " domain
fi
	echo "Generating virtual host for $domain...."
	touch /etc/apache2/sites-available/$domain.conf
	cat >/etc/apache2/sites-available/$domain.conf <<EOF
<VirtualHost *:80>
	ServerName $domain
	ServerAlias www.$domain
	DocumentRoot /var/www/html
	<Directory /var/www/html/>
                AllowOverride All
		Options +Indexes
                Order allow,deny
                Allow from all
                Require all granted
	</Directory>
</VirtualHost>
EOF
	echo "Done!"
	service apache2 reload
	a2ensite $domain.conf
	service apache2 reload
	exit
fi
