# Dockerizing DASH
This directory includes Dockerfiles for the [DASH](https://github.com/akvo/akvo-dash) project. Right now it's composed of [nginx-proxy](https://github.com/jwilder/nginx-proxy) as the public proxy, a `frontend` container to serve static assets, and a `backend` container running a pre-compiled clojure application.
SSL is supported and the default behaviour is to redirect port 80 to 443, so HTTPS is always preferred when available.

In addition, there is a `Makefile` for the sake of orchestrating this multi-container application.
