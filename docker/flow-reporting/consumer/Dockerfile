FROM clojure
MAINTAINER Akvo Foundation <devops@akvo.org>

WORKDIR /usr/src/app

RUN git clone https://github.com/akvo/akvo-reporting-consumer && \
    cd akvo-reporting-consumer && \
    git checkout master && \
    lein uberjar && \
    mv target/reporting-consumer.jar ../reporting-consumer.jar

RUN mkdir -p /tmp/repos
CMD ["java", "-jar", "reporting-consumer.jar", "/tmp/repos", "live.edn"]
