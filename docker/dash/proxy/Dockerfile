FROM jwilder/nginx-proxy
MAINTAINER Akvo Foundation <devops@akvo.org>

RUN apt-get update && \
    apt-get install -y -q --no-install-recommends git curl xz-utils && \
    curl https://nodejs.org/dist/v5.7.0/node-v5.7.0-linux-x64.tar.xz | tar -xJf - --strip-components=1 -C /usr && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN git clone https://github.com/akvo/akvo-dash.git && \
    cd akvo-dash/client && \
    npm set progress=false && \
    npm install && \
    npm run build && \
    cp index.html /usr/share/nginx/html && \
    mkdir /usr/share/nginx/html/assets && \
    cp dist/* /usr/share/nginx/html/assets && \
    cd /tmp && rm -rf akvo-dash