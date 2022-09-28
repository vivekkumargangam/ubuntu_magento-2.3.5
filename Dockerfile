FROM ubuntu:18.04
MAINTAINER Kensium
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install vim curl nano sudo wget net-tools -y &&\
# nginx installation
apt install software-properties-common -y && add-apt-repository -y ppa:ondrej/nginx && apt update && apt install nginx -y &&\
# php installation
sudo apt install software-properties-common && sudo add-apt-repository ppa:ondrej/php && apt update && apt install php7.3 php7.3-common php7.3-mysql php7.3-xml php7.3-xmlrpc php7.3-curl php7.3-gd php7.3-imagick php7.3-cli php7.3-dev php7.3-imap php7.3-mbstring php7.3-soap php7.3-zip php7.3-bcmath php7.3-intl php7.3-fpm zip unzip php-zip -y && apt remove apache2 && sudo apt-get purge apache2 && sudo apt-get autoremove apache2 && sudo apt-get autoclean  apache2 && rm -rf /usr/sbin/apache2 /usr/lib/apache2 /etc/apache2 &&\
# mysql installation
apt install mysql-server -y && service mysql start && mysql -uroot -proot -e "CREATE DATABASE mydb; CREATE USER 'vivek'@'localhost' IDENTIFIED BY 'Vivek@1996'; GRANT ALL PRIVILEGES ON *.* TO 'vivek'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;" &&\
# elasticsearch installation
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - && echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list && apt-get update && apt-get install default-jdk gnupg elasticsearch=7.6.0 -y &&\
# composer installation
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && php composer-setup.php && php -r "unlink('composer-setup.php');" && sudo mv composer.phar /usr/local/bin/composer && composer self-update 1.10.22
COPY php.ini /etc/php/7.4/cli/php.ini
COPY elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
COPY default /etc/nginx/sites-available/
COPY auth.json /root/.composer/auth.json
COPY env.php /var/www/html
COPY servicesstart.bkp.sh /
ENTRYPOINT ["/servicesstart.bkp.sh"]

