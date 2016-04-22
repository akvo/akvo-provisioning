FROM clojure
MAINTAINER Akvo Foundation <devops@akvo.org>

WORKDIR /usr/src/app
RUN git clone https://github.com/akvo/akvo-dash.git && \
    cd akvo-dash/backend && \
    git checkout master && \
    lein deps && \
    mv "$(lein uberjar | sed -n 's/^Created \(.*standalone\.jar\)/\1/p')" ../../app-standalone.jar && \
    rm -rf ~/.m2

CMD ["java", "-jar", "app-standalone.jar"]
