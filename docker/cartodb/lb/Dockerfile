FROM jwilder/nginx-proxy
MAINTAINER Akvo Foundation <devops@akvo.org>

# Default single configuration for cartodb vhosts
ADD default.conf /etc/nginx/vhost.d/default

# Default configuration for vhosts' locations
ADD default_location /etc/nginx/vhost.d/default_location

# Default proxy settings
ADD proxy.conf /etc/nginx/proxy.conf
