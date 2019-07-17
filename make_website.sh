#!/bin/bash

echo -n "Enter website name and press [ENTER]: "
read name
printf "\n"

echo -n "Enter website type and press [ENTER]: "
printf "\n"
echo -n "[1] Default "
printf "\n"
echo -n "[2] Laravel "
printf "\n"
echo -n "[3] Wordpress "
printf "\n"
read websitetype

# Creazione folder principale
cd /var/www/
mkdir $name
cd $name

PUBLIC=""
MAKEPUBLIC="0"

# Se tipo default creo la public_html interna
if [ "$websitetype" = "1" ]
then
	PUBLIC="public_html/"
	MAKEPUBLIC="1"
fi

# Se tipo laravel imposto soltanto la public ma non la faccio creare
if [ "$websitetype" = "2" ]
then
	PUBLIC="public/"
	MAKEPUBLIC="0"
fi

# Se tipo default creo la public_html interna
if [ "$websitetype" = "3" ]
then
	PUBLIC="public_html/"
	MAKEPUBLIC="1"
fi

# Creo la public_html
if [ "$MAKEPUBLIC" = "1" ]
then
	mkdir "$PUBLIC"

	chgrp www-data -R public_html
	chown developer -R public_html
	chmod 775 -R public_html
fi

# Creo il sites-available
cd /etc/apache2/sites-available/
touch $name.conf
echo "<VirtualHost *:80>
	ServerName $name
	ServerAlias
	ServerAdmin sysadm@acktel.com
	DocumentRoot /var/www/$name/$PUBLIC
	<Directory /var/www/$name/$PUBLIC >
		Options All
		AllowOverride All
		Require all granted
	</Directory>
	ErrorLog \${APACHE_LOG_DIR}/$name-error.log
	CustomLog \${APACHE_LOG_DIR}/$name-access.log combined
</VirtualHost>" > $name.conf

a2ensite $name.conf
service apache2 reload

echo -n "Website $name type with $websitetype created"
printf "\n"

# Se tipo wordpress faccio partire il download con il WP-CLI
if [ "$websitetype" = "3" ]
then
	cd /var/www/$name/$PUBLIC
	sudo wp core download --locale=it_IT --allow-root
	
	echo -n "Wordpress was downloaded"
	printf "\n"
	
	#echo -n "Enter DB name and press [ENTER]: "
	#read dbname
	#printf "\n"

	#mysql -uroot -e "create database $dbname;"	
	
fi
