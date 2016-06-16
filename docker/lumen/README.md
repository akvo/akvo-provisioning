# Dockerizing Akvo Lumen
This directory includes Dockerfiles for the [Akvo Lumen](https://github.com/akvo/akvo-lumen) project. Right now it's composed of [nginx-proxy](https://github.com/jwilder/nginx-proxy) as the public proxy, a `frontend` container to serve static assets, and a `backend` container running a pre-compiled clojure application.
SSL is supported and the default behaviour is to redirect port 80 to 443, so HTTPS is always preferred when available.

In addition, there is a `Makefile` for the sake of orchestrating this multi-container application. The makefile and the docker-compose machinery expect configs to be provided via environment variables. Use the provided template to craft a secrets file which can then be sourced to get required variables exported to the environment.

```
$ cp ./secrets.template secrets
$ source ./secrets
```

