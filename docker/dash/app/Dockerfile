FROM ubuntu:14.04
MAINTAINER Akvo Foundation <devops@akvo.org>

ENV DEBIAN_FRONTEND noninteractive

RUN localedef -i en_US -c -f UTF-8 -A \
    /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

# Install build dependencies

RUN apt-get install -y -q software-properties-common && \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get update && \
    apt-get install -y -q nginx git curl

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
    apt-get update && \
    apt-get install -y -q nodejs && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    mkdir /opt/dash

WORKDIR /opt/dash

RUN git clone https://github.com/akvo/akvo-dash && \
    cd akvo-dash/client && \
    npm set progress=false && \
    npm install && \
    npm run build && \
    rm -rf node_modules && \
    cp index.html /usr/share/nginx/html && \
    mkdir /usr/share/nginx/html/assets && \
    cp dist/* /usr/share/nginx/html/assets && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log


EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]