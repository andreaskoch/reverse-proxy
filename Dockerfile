FROM phusion/baseimage:latest

MAINTAINER Andreas Koch <andy@ak7.io>

# Set correct environment
ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN /usr/sbin/enable_insecure_key

RUN apt-get -qy update

# Install supervisor
RUN apt-get install -qy supervisor
RUN mkdir -p /var/log/supervisor

# Configure Supervisord
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Download ngx_pagespeed
WORKDIR /usr/src
ENV NPS_VERSION 1.9.32.1
RUN apt-get install -qy wget build-essential zlib1g-dev libpcre3 libpcre3-dev unzip
RUN wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip
RUN unzip release-${NPS_VERSION}-beta.zip
RUN mv ngx_pagespeed-release-${NPS_VERSION}-beta ngx_pagespeed
WORKDIR /usr/src/ngx_pagespeed
RUN wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
RUN tar -xzvf ${NPS_VERSION}.tar.gz

# Install Nginx with support for page-speed
WORKDIR /usr/src
ENV NGINX_VERSION 1.6.1
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar -xvzf nginx-${NGINX_VERSION}.tar.gz
RUN mv nginx-${NGINX_VERSION} nginx-source
WORKDIR /usr/src/nginx-source
RUN ./configure --add-module=/usr/src/ngx_pagespeed
RUN make 
RUN make install
WORKDIR /

# Configure Cron
ADD bin/configure-cron.sh /configure-cron.sh
RUN /bin/bash /configure-cron.sh

EXPOSE 80 443 22

# Start Nginx and PHP-FPM
CMD ["supervisord", "-n"]
