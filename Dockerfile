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

# Install nginx
RUN apt-get install -qy nginx
RUN rm -rf /etc/nginx/conf.d /etc/nginx/sites-enabled /etc/nginx/sites-available

# Configure Cron
ADD bin/configure-cron.sh /configure-cron.sh
RUN /bin/bash /configure-cron.sh

EXPOSE 80 443 22

# Start Nginx and PHP-FPM
CMD ["supervisord", "-n"]
