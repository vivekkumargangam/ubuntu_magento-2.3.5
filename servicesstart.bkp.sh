#!/bin/bash
service nginx start
service elasticsearch start
service php7.3-fpm start
service mysql start
cd /var/www/html
composer self-update 1.10.16
composer create-project --no-interaction --repository-url=https://repo.magento.com/ magento/project-community-edition=2.3.5 /var/www/html/magento
cd /
./start.sh
watch netstat -tulpn
