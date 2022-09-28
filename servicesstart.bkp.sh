#!/bin/bash
service nginx start
service elasticsearch start
service php7.3-fpm start
service mysql start
cd /var/www/html
clear composer cache
composer create-project --no-interaction --repository-url=https://repo.magento.com/ magento/project-community-edition=2.3.5 /var/www/html/magento
cd /var/www/html/magento
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R :www-data .
chmod u+x bin/magento
bin/magento setup:install \
--base-url=http://vivek123.com/ \
--db-host=localhost \
--db-name=mydb \
--db-user=vivek \
--db-password=Vivek@1996 \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=admin@admin.com \
--admin-user=admin \
--admin-password=admin123 \
--language=en_US \
--currency=USD \
--timezone=America/Chicago \
--use-rewrites=1 \
cp /var/www/html/env.php /var/www/html/magento/app/etc/env.php
#cp /root/.composer/auth.json /var/www/html/magento/var/composer_home/auth.json
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy -f
php bin/magento cache:clean
php bin/magento cache:flush
watch netstat -tulpn

