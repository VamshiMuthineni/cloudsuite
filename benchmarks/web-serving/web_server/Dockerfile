FROM ubuntu:16.04
LABEL maintainer="Mark Sutherland <mark.sutherland@epfl.ch>"

USER root
ENV DEBIAN_FRONTEND noninteractive
RUN export RUNLEVEL=1
RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d
RUN apt-get update && \
	apt-get install -y --force-yes software-properties-common && \
	apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 && \
	add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main" && \
	apt-get update && \
	apt-get install --force-yes -y \
	git \
	nginx \
	php7.0 php7.0-gd \
	php7.0-mysql php7.0-curl \
	php7.0-fpm php-memcache \
	mysql-server
	
RUN apt-get update && \
	apt-get install -y --force-yes software-properties-common wget git build-essential && \
	add-apt-repository -s "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main" && \
	apt-get update && \
	wget https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz && \
	tar -xvzf libevent-2.1.11-stable.tar.gz && \
	cd libevent-2.1.11-stable && \
	./configure --prefix=/usr --disable-dependency-tracking --disable-static && make && \
	make install && \
	install  -v -m755 -d /usr/share/doc/libevent-2.1.11/api && \
	apt-get build-dep -y --force-yes hhvm-nightly && \
	git clone git://github.com/facebook/hhvm.git && \
	cd hhvm && \
	git submodule update --init --recursive && \
	cmake -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_CXX_COMPILER=/usr/bin/g++ -DMYSQL_UNIX_SOCK_ADDR=/var/run/mysqld/mysqld.sock . && \
	make -j 1 && \
	make install
# Increase the open file limit
COPY files/limits.conf.append /tmp/
RUN cat /tmp/limits.conf.append >> /etc/security/limits.conf && rm -f /tmp/limits.conf.append

# Checkout the Elgg installation
COPY files/elgg_installation /usr/share/nginx/html/elgg

WORKDIR /usr/share/nginx/html
# Copy over the settings.php
COPY files/settings.php elgg/engine/settings.php

# Make the Elgg data directory
RUN mkdir /elgg_data
RUN chmod a+rw /elgg_data

# Copy over the Nginx Server configuration
COPY files/nginx_sites_avail.append /tmp/

# Copy over the Nginx HHVM Server configuration
COPY files/nginx_sites_avail_hhvm.append /tmp/
COPY files/configure_hhvm.sh /tmp/

ADD files/elgg_db.dump /elgg_db.dump

RUN service nginx restart

RUN service php7.0-fpm restart

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

EXPOSE 8080

CMD ["/etc/bootstrap.sh", "-d"]
