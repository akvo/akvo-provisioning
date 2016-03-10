FROM clojure
MAINTAINER Akvo Foundation <devops@akvo.org>

WORKDIR /usr/src/app
RUN git clone https://github.com/akvo/akvo-dash.git

WORKDIR /usr/src/app/akvo-dash/backend
CMD ["lein","run"]
