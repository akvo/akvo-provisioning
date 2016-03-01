FROM ubuntu:14.04
MAINTAINER Akvo Foundation <devops@akvo.org>

# Configure locales
ENV DEBIAN_FRONTEND noninteractive
RUN localedef -i en_US -c -f UTF-8 -A \
    /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

RUN useradd --base-dir /opt --home /opt/dash --create-home dash

# Install build dependencies
RUN apt-get install -y -q software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y -q --no-install-recommends git wget openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

RUN cd /usr/local/bin && \
    wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod a+x ./lein

USER dash

RUN lein

WORKDIR /opt/dash

RUN git clone https://github.com/akvo/akvo-dash.git && \
    cd akvo-dash/backend && \
    lein deps && lein uberjar && \
    rm -rf /opt/dash/.m2

EXPOSE 3000

ADD ./run /opt/run

CMD ["/bin/bash", "/opt/run"]
