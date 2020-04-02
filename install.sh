#! /bin/bash

cur_dir=$(pwd)
php_file="php-7.3.16"
php_url="https://www.php.net/distributions/php-7.3.16.tar.bz2"
cmake_file="cmake-3.16.5"
cmake_url="https://github.com/Kitware/CMake/releases/download/v3.16.5/cmake-3.16.5.tar.gz"
libzip_file="libzip-1.6.1"
libzip_url="https://libzip.org/download/libzip-1.6.1.tar.gz"
imagick_file="imagick-3.4.4"
imagick_url="https://pecl.php.net/get/imagick-3.4.4.tgz"
wordpress_file="wordpress-latest"
wordpress_url="https://cn.wordpress.org/latest-zh_CN.tar.gz"



cat>mime.types<<EOF
types {
    text/html                                        html htm shtml;
    text/css                                         css;
    text/xml                                         xml;
    image/gif                                        gif;
    image/jpeg                                       jpeg jpg;
    application/javascript                           js;
    application/atom+xml                             atom;
    application/rss+xml                              rss;

    text/mathml                                      mml;
    text/plain                                       txt;
    text/vnd.sun.j2me.app-descriptor                 jad;
    text/vnd.wap.wml                                 wml;
    text/x-component                                 htc;

    image/png                                        png;
    image/svg+xml                                    svg svgz;
    image/tiff                                       tif tiff;
    image/vnd.wap.wbmp                               wbmp;
    image/webp                                       webp;
    image/x-icon                                     ico;
    image/x-jng                                      jng;
    image/x-ms-bmp                                   bmp;

    font/woff                                        woff;
    font/woff2                                       woff2;
    application/x-font-truetype        	  			 ttf;
    application/x-font-opentype        	  			 otf;

	application/x-sh								 sh;
    application/java-archive                         jar war ear;
    application/json                                 json;
    application/mac-binhex40                         hqx;
    application/msword                               doc;
    application/pdf                                  pdf;
    application/postscript                           ps eps ai;
    application/rtf                                  rtf;
    application/vnd.apple.mpegurl                    m3u8;
    application/vnd.google-earth.kml+xml             kml;
    application/vnd.google-earth.kmz                 kmz;
    application/vnd.ms-excel                         xls;
    application/vnd.ms-fontobject                    eot;
    application/vnd.ms-powerpoint                    ppt;
    application/vnd.oasis.opendocument.graphics      odg;
    application/vnd.oasis.opendocument.presentation  odp;
    application/vnd.oasis.opendocument.spreadsheet   ods;
    application/vnd.oasis.opendocument.text          odt;
    application/vnd.openxmlformats-officedocument.presentationml.presentation
                                                     pptx;
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                                                     xlsx;
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
                                                     docx;
    application/vnd.wap.wmlc                         wmlc;
    application/x-7z-compressed                      7z;
    application/x-cocoa                              cco;
    application/x-java-archive-diff                  jardiff;
    application/x-java-jnlp-file                     jnlp;
    application/x-makeself                           run;
    application/x-perl                               pl pm;
    application/x-pilot                              prc pdb;
    application/x-rar-compressed                     rar;
    application/x-redhat-package-manager             rpm;
    application/x-sea                                sea;
    application/x-shockwave-flash                    swf;
    application/x-stuffit                            sit;
    application/x-tcl                                tcl tk;
    application/x-x509-ca-cert                       der pem crt;
    application/x-xpinstall                          xpi;
    application/xhtml+xml                            xhtml;
    application/xspf+xml                             xspf;
    application/zip                                  zip;

    application/octet-stream                         bin exe dll;
    application/octet-stream                         deb;
    application/octet-stream                         dmg;
    application/octet-stream                         iso img;
    application/octet-stream                         msi msp msm;

    audio/midi                                       mid midi kar;
    audio/mpeg                                       mp3;
    audio/ogg                                        ogg;
    audio/x-m4a                                      m4a;
    audio/x-realaudio                                ra;

    video/3gpp                                       3gpp 3gp;
    video/mp2t                                       ts;
    video/mp4                                        mp4;
    video/mpeg                                       mpeg mpg;
    video/quicktime                                  mov;
    video/webm                                       webm;
    video/x-flv                                      flv;
    video/x-m4v                                      m4v;
    video/x-mng                                      mng;
    video/x-ms-asf                                   asx asf;
    video/x-ms-wmv                                   wmv;
    video/x-msvideo                                  avi;
	application/vnd.rn-realmedia          			 rmvb;
	video/x-matroska								 mkv;
}
EOF

cat>my.cnf<<EOF
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

port=3306
bind-address=0.0.0.0
lower_case_table_names = 1
character-set-server=utf8mb4

[mysql]
default-character-set=utf8mb4

[client]
loose-local-infile=1
default-character-set=utf8mb4
EOF

cat>nginx.conf<<EOF
user  nginx;
worker_processes  auto;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
    worker_connections  1024;
}
http {
	charset utf-8;
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    keepalive_timeout  65;
    server_tokens off;
    gzip  on;
	gzip_static on;
	gzip_vary on;
	gzip_min_length 1k;
	gzip_comp_level 9;
	gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript image/svg+xml;
	client_max_body_size 110m;
	include /etc/nginx/sites-enabled/*.conf;
}
EOF

cat>nginx.repo<<EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
EOF


cat>wordpress.conf<<EOF
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	root /usr/share/nginx/wordpress;
	index  index.php index.html index.htm;
	include /etc/nginx/default.d/*.conf;
	location / {
		try_files $uri $uri/ /index.php$is_args$args;
	}
	location ~ \.php$ {
		fastcgi_read_timeout 600;
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
		fastcgi_buffers 16 16k;
		fastcgi_buffer_size 32k;
		include        fastcgi_params;
	}
	location ~ /\.(?!well-known\/) {
    		deny all;
	}
	location /wp-content/uploads {
    		location ~ \.php$ {
			deny all;
		}
	}
	location ~* /(?:uploads|files)/.*\.php$ {
		proxy_read_timeout 300; 
		deny all;
	}
	location = /favicon.ico {
        log_not_found off;
		access_log off;
		expires max;
	}
	location = /robots.txt {
		allow all;
		log_not_found off;
		access_log off;
	}	
	location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        access_log off;
        log_not_found off;
	}
}
EOF

function install_cleanup(){
    cd ${cur_dir}
    rm -rf ${php_file} ${php_file}.tar.bz2
    rm -rf ${libzip_file} ${libzip_file}.tar.gz
    rm -rf ${cmake_file} ${cmake_file}.tar.gz
	rm -rf ${wordpress_file} ${wordpress_file}.tar.gz
	rm -rf ${imagick_file} ${imagick_file}.tgz
	rm -rf ${configs_file} ${configs_file}.tar.gz
	rm -f mysql80-community-release.noarch.rpm
	if [ -f /tmp/tmp_1g_swap ]; then
        swapoff /tmp/tmp_1g_swap
        rm -rf /tmp/tmp_1g_swap
    fi
}

function download(){
    local filename=$(basename $1)
    if [ -f ${1} ]; then
        echo "${filename} [found]"
    else
        echo "${filename} not found, download now..."
        wget --no-check-certificate -c -t3 -T60 -O ${1} ${2}
        if [ $? -ne 0 ]; then
            echo -e "Error Download ${filename} failed."
            exit 1
        fi
    fi
}

function error_detect_depends(){
    local command=$1
    local depend=`echo "${command}" | awk '{print $4}'`
    echo -e "Info: Starting to install package ${depend}"
    ${command} > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "Error! Failed to install ${depend}"
        exit 1
    fi
}

# query public ip
echo "Querying public IP adress..."
pub_ip=`curl http://members.3322.org/dyndns/getip | grep "[0-9]\{1,3\}[.][0-9]\{1,3\}[.][0-9]\{1,3\}[.][0-9]\{1,3\}"`
if [ $pub_ip = "" ]; then
    echo "Cannot found public IP adress."
    exit 1
else
    echo "Your public network IP is $pub_ip"
fi

# check system version
if [ ! -f /etc/redhat-release ]; then
    echo "Only supported CentOS 7 64bit."
    exit 1
fi

# check user
user=www-data
group=www-data

egrep "^$group" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
    groupadd $group
fi

egrep "^$user" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    useradd -g $group $user
fi

# input domain 
echo "Please enter domain for wordpress"
read -p "(Default domain: ${pub_ip}):" domain
[ -z "${domain}" ] && domain=${pub_ip}
echo
echo "domain = ${domain}"
echo

# input mysql password
key="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$!%(^."
num=${#key}
radommysqlpassword=''
for i in {1..16}
do
    index=$[RANDOM%num]
    radommysqlpassword=$radommysqlpassword${key:$index:1}
done
radommysqlpassword="!Tr8${radommysqlpassword}"

echo "Please enter password for mysql root user"
read -p "(Default password: ${radommysqlpassword}):" mysql_password
[ -z "${mysql_password}" ] && mysql_password=${radommysqlpassword}
echo "\npassword = ${mysql_password}\n"


# input wordpress db name
defalut_wordpress_dbname="wordpress"
echo "Please enter database name for wordpress"
read -p "(Default dbname: ${defalut_wordpress_dbname}):" wordpress_dbname
[ -z "${wordpress_dbname}" ] && wordpress_dbname=${defalut_wordpress_dbname}
echo "\ndatabase name = ${wordpress_dbname}\n"

#char
SAVEDSTTY=$(stty -g)
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY

#install dependencies

# gcc & c++
gcc_path=$(command -v gcc)
if [ "${gcc_path}" == "" ]; then
    error_detect_depends "yum -y install gcc"
fi
cplusplus_path=$(command -v c++)
if [ "${cplusplus_path}" == "" ]; then
    error_detect_depends "yum -y install gcc-c++"
fi
yum_depends=(
    autoconf yum-utils bzip2 bzip2-devel libpng libpng-devel freetype-devel gmp-devel readline-devel curl curl-devel libxml2-devel libjpeg-devel bison openssl-devel wget tar ImageMagick-devel
)
for depend in ${yum_depends[@]}; do
    error_detect_depends "yum -y install ${depend}"
done

# cmake
cmake_path=$(command -v cmake)
if [ "${cmake_path}" == "" ]; then
    cd ${cur_dir}
    download "${cmake_file}.tar.gz" "${cmake_url}"
    tar -zxf ${cmake_file}.tar.gz
    cd ${cmake_file}
    ./bootstrap --prefix=/usr --datadir=share/cmake --docdir=doc/cmake && make -j${processor_count} && make install
    if [ $? -ne 0 ]; then
        echo -e "Error ${cmake_file} install failed."
        install_cleanup
        exit 1
    fi
else
    echo -e "[${green}Info cmake already installed."
fi

# libzip
libzip_path=$(command -v libzip)
if [ ! -f /usr/lib/libzip.so ] && [ ! -f /usr/lib64/libzip.so ]; then
    cd ${cur_dir}
    download "${libzip_file}.tar.gz" "${libzip_url}"
    tar -zxf ${libzip_file}.tar.gz
    cd ${libzip_file}
    mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make -j${processor_count} && make install
    if [ $? -ne 0 ]; then
        echo -e "Error ${libzip_file} install failed."
        install_cleanup
        exit 1
    fi
else
    echo -e "[${green}Info libzip already installed."
fi

# configs_file

# install php

if [ ! -f /usr/bin/php ] && [ ! -f /usr/local/bin/php ]; then
        cd ${cur_dir}
        download "${php_file}.tar.bz2" "${php_url}"
        tar -jxf ${php_file}.tar.bz2
        cd ${php_file}
        ./configure --prefix=/usr \
   --sysconfdir=/etc/php \
   --with-config-file-path=/etc/php \
   --with-config-file-scan-dir=/etc/php/php.d \
   --bindir=/usr/bin \
   --docdir=/usr/share/doc \
   --sbindir=/usr/sbin \
   --libdir=/usr/lib64/php \
   --with-libdir=/usr/lib64/php \
   --libexecdir=/usr/libexec \
   --localstatedir=/var \
   --runstatedir=/run \
   --includedir=/usr/include \
   --localedir=/usr/local \
   --datarootdir=/usr/share \
   --datadir=/usr/share/php \
   --mandir=/usr/share/man \
   --infodir=/usr/share/info \
   --enable-fpm \
   --with-fpm-user=www-data \
   --with-fpm-group=www-data \
   --enable-mysqlnd \
   --enable-mysqlnd-compression-support \
   --enable-json \
   --with-openssl-dir \
   --with-jpeg-dir \
   --with-png-dir \
   --with-zlib-dir \
   --with-freetype-dir \
   --enable-gd-jis-conv \
   --enable-ftp \
   --enable-filter \
   --enable-fileinfo \
   --with-curl \
   --with-iconv \
   --with-bz2 \
   --with-zlib \
   --with-pcre-regex \
   --with-openssl \
   --enable-dom \
   --with-gettext \
   --with-mysqli=mysqlnd \
   --enable-pdo \
   --with-pdo-mysql=mysqlnd \
   --with-pdo-sqlite \
   --enable-simplexml \
   --enable-session \
   --enable-sysvsem \
   --enable-sysvmsg \
   --enable-sockets \
   --with-libxml-dir \
   --enable-mysqlnd-compression-support \
   --with-pear \
   --enable-opcache \
   --with-xmlrpc \
   --with-mhash \
   --with-sqlite3 \
   --enable-bcmath \
   --with-cdb \
   --enable-exif \
   --with-gd \
   --with-gmp \
   --enable-mbstring \
   --enable-mbregex \
   --enable-mbregex-backtrack \
   --with-onig \
   --with-readline \
   --enable-shmop \
   --enable-zip
    if [ $? -ne 0 ]; then
        echo -e "Error! ${php_file} install failed."
        install_cleanup
        exit 1
    fi
    
    make -j${processor_count}&& make install
    if [ $? -ne 0 ]; then
        echo -e "Error! ${php_file} install failed."
        install_cleanup
        exit 1
    fi
else
    echo -e "php already installed."
fi



# config php
cd ${cur_dir}
cd ${php_file}
if [ ! -d "/tmp/php" ]; then
    mkdir /tmp/php
    if [ $? -ne 0 ]; then
        echo -e "Error! create php opcache dir failed."
        install_cleanup
        exit 1
    fi
fi
if [ ! -d "/tmp/php/opcache" ]; then
    mkdir /tmp/php/opcache
    if [ $? -ne 0 ]; then
        echo -e "Error! create php opcache dir failed."
        install_cleanup
        exit 1
    fi
fi
	
cp php.ini-production /etc/php/php.ini
cp sapi/fpm/php-fpm.conf /etc/php/php-fpm.conf
cp sapi/fpm/www.conf /etc/php/php-fpm.d/www.conf
cp sapi/fpm/php-fpm.service /etc/systemd/system/php-fpm.service

extension_dir=$(php-config --extension-dir)
extension_dir=${extension_dir//\//\\/}
sed -i 's/;extension_dir = ".\/"/extension_dir = "'$extension_dir'"/' /etc/php/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/php.ini
sed -i 's/;opcache.enable=1/opcache.enable=1/' /etc/php/php.ini
sed -i 's/;opcache.enable_cli=0/opcache.enable_cli=1/' /etc/php/php.ini
sed -i 's/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=10000/' /etc/php/php.ini
sed -i 's/;opcache.file_cache=/opcache.file_cache = "\/tmp\/php\/opcache"/' /etc/php/php.ini
sed -i '/;extension=xsl/a\zend_extension=opcache.so' /etc/php/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/php/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 108M/' /etc/php/php.ini


# install_imagick
cd ${cur_dir}
download "${imagick_file}.tgz" "${imagick_url}"
tar -xf ${imagick_file}.tgz
cd ${imagick_file}
phpize && ./configure --prefix=/usr && make -j${processor_count} && make install
if [ $? -ne 0 ]; then
    echo -e "Error ${imagick_file} install failed."
    install_cleanup
    exit 1
fi
sed -i '/;extension=xsl/a\extension=imagick.so' /etc/php/php.ini

# install_nginx
cd ${cur_dir}
cd ${configs_file}
mv nginx.repo /etc/yum.repos.d
error_detect_depends "yum -y install nginx"

# config_nginx
cd ${cur_dir}
cd ${configs_file}
mv -f nginx.conf /etc/nginx
mv -f mime.types /etc/nginx
if [ ! -d "/etc/nginx/modules-available" ]; then
    mkdir /etc/nginx/modules-available
    if [ $? -ne 0 ]; then
        echo -e "Error create nginx modules-available dir failed."
        install_cleanup
        exit 1
    fi
fi
if [ ! -d "/etc/nginx/modules-enabled" ]; then
    mkdir /etc/nginx/modules-enabled
    if [ $? -ne 0 ]; then
        echo -e "Error create nginx modules-enabled dir failed."
        install_cleanup
        exit 1
    fi
fi
if [ ! -d "/etc/nginx/sites-available" ]; then
    mkdir /etc/nginx/sites-available
    if [ $? -ne 0 ]; then
        echo -e "Error create nginx sites-available dir failed."
        install_cleanup
        exit 1
    fi
fi
if [ ! -d "/etc/nginx/sites-enabled" ]; then
    mkdir /etc/nginx/sites-enabled
    if [ $? -ne 0 ]; then
        echo -e "Error create nginx sites-enabled dir failed."
        install_cleanup
        exit 1
    fi
fi
if [ ! -d "/etc/nginx/default.d" ]; then
    mkdir /etc/nginx/default.d
    if [ $? -ne 0 ]; then
        echo -e "Error create nginx default.d dir failed."
        install_cleanup
        exit 1
    fi
fi
# 	install_mysql
cd ${cur_dir}
if [ "$sys_main_ver" == '7' ]; then
    download "mysql80-community-release.noarch.rpm" "https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm"
else
    download "mysql80-community-release.noarch.rpm" "https://repo.mysql.com/mysql80-community-release-el8-1.noarch.rpm"
fi
rpm -Uvh mysql80-community-release.noarch.rpm

error_detect_depends "yum -y install mysql-community-server"
mv -f configs/my.cnf /etc
systemctl start mysqld

# config_mysql
get_mysql_temp_password
	
cat > ~/.my.cnf <<EOT
[mysql]
user=root
password="$mysql_temp_password"
EOT
systemctl restart mysqld
mysql  --connect-expired-password  -e "alter USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysql_password}';"
systemctl restart mysqld

cat > ~/.my.cnf <<EOT
[mysql]
user=root
password="$mysql_password"
EOT
	
mysql  --connect-expired-password  -e "create USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '${mysql_password}';"
mysql  --connect-expired-password  -e "grant all privileges on *.* to 'root'@'localhost' with grant option;"
mysql  --connect-expired-password  -e "grant all privileges on *.* to 'root'@'%' with grant option;"
mysql  --connect-expired-password  -e "create database ${wordpress_dbname};"
mysql  --connect-expired-password  -e "FLUSH PRIVILEGES;"

rm -f ~/.my.cnf
systemctl restart mysqld

# install_wordpress
cd ${cur_dir}
download "${wordpress_file}.tar.gz" "${wordpress_url}"
tar -zxf ${wordpress_file}.tar.gz
mv -f wordpress /usr/share/nginx

# config_wordpress
cd /usr/share/nginx/wordpress
cp wp-config-sample.php wp-config.php

sed -i 's/database_name_here/'$wordpress_dbname'/' wp-config.php
sed -i 's/username_here/root/' wp-config.php
sed -i 's/password_here/'$mysql_password'/' wp-config.php
sed -i 's/localhost/127.0.0.1/' wp-config.php

chown -R www-data:www-data /usr/share/nginx/wordpress
chmod -R 755 /usr/share/nginx/wordpress

cd ${cur_dir}
cd ${configs_file}

if [ "${domain}" == "${server_ip}" ];then
    sed -i 'N;10iserver_name '$domain';' wordpress.conf
fi

mv -f wordpress.conf /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled


# config_firewall
systemctl status firewalld > /dev/null 2>&1
if [ $? -eq 0 ]; then
    firewall-cmd --zone=public --add-port=80/tcp --permanent
    firewall-cmd --zone=public --add-port=443/tcp --permanent
    firewall-cmd --reload
fi
# install_completed
systemctl restart nginx
systemctl enable nginx
systemctl start php-fpm
systemctl enable php-fpm

cd ${cur_dir}
cat > mysql-config.txt <<EOT
Your Server IP        		: ${server_ip}
Your MySQL Port       		: 3306
Your MySQL User       		: root
Your MySQL Password   		: ${mysql_password}
EOT

echo
echo -e "wordpress install completed!"
echo -e "Your Web Site URL     	 	 :  http://${domain} "
echo -e "Your Server IP        		 :  ${server_ip} "
echo -e "Your MySQL Port       		 :  3306 "
echo -e "Your MySQL User       		 :  root "
echo -e "Your MySQL Password   		 :  ${mysql_password} "
echo -e "Your WordPress DataBase Name:  ${wordpress_dbname} "

# clean downloaded packages
install_cleanup
