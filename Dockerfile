FROM ubuntu:18.04

RUN apt-get update && apt-get install -y apache2

ADD ["linux/Ubuntu 18.04/libharbour.so.3.2.0", "/var/www/html/"]
ADD ["linux/Ubuntu 18.04/mod_harbour.so", "/usr/lib/apache2/modules/"]
ADD ["linux/Ubuntu 19.04/mod_harbour.conf", "linux/Ubuntu 19.04/mod_harbour.load", "/root/"]

RUN \
    # Adding the Apache config.
    cat /root/mod_harbour.load >> /etc/apache2/apache2.conf && \
    cat /root/mod_harbour.conf >> /etc/apache2/apache2.conf && \
    # Changing the path to serve to /var/www/html2 so we can mount a volume in
    # that folder without worrying about libharbour.so.3.2.0.
    mkdir /var/www/html2 && \
    sed -i "s|/var/www/html|/var/www/html2|g" /etc/apache2/sites-enabled/000-default.conf && \
    # Apache needs the environment variables in /etc/apache2/envvars to be set.
    echo ". /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND" > /root/run_apache.sh && \
    # Apache expects this folder to exist.
    mkdir -p /var/run/apache2

EXPOSE 80
VOLUME /var/www/html2

CMD ["/bin/sh", "/root/run_apache.sh"]