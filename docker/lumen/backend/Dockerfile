FROM clojure
MAINTAINER Akvo Foundation <devops@akvo.org>

WORKDIR /usr/src/app
RUN git clone https://github.com/akvo/akvo-lumen.git && \
    git checkout release/0.1.0 && \
    cd akvo-lumen/backend && \
    lein deps && \
    lein uberjar && \
    mv target/uberjar/akvo-lumen.jar ../../akvo-lumen.jar && \
    rm -rf ~/.m2

CMD ["java", "-jar", "akvo-lumen.jar"]
