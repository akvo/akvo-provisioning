FROM clojure
MAINTAINER Akvo Foundation <devops@akvo.org>

WORKDIR /usr/src/app
RUN git clone https://github.com/akvo/akvo-dash.git
    cd akvo-dash/backend && \
    lein deps && \
    mv "$(lein uberjar | sed -n 's/^Created \(.*standalone\.jar\)/\1/p')" ../../app-standalone.jar && \
    rm -rf /usr/src/app/.m2

CMD ["java", "-jar", "app-standalone.jar"]
