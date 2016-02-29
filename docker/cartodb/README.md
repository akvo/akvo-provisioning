# Dockerizing CartoDB
This directory includes all what's needed to dockerize the five main components CartoDB is composed of, namely postgreSQL, redis, [Maps API](https://github.com/CartoDB/Windshaft-cartodb), [SQL API](https://github.com/CartoDB/CartoDB-SQL-API), and the main [rails app](https://github.com/CartoDB/cartodb). 
Current `dev` and `test` configurations are aimed to setup a testing environment, locally and remotely respectively, where the service is available at `http://cdb.akvotest.org`. Obviously a proper entry for such subdomain into `/etc/hosts` (pointing to `$DOCKER_HOST`) must be added to access the service if running locally (`dev` environment). This seems to be a good enough way to manage different environments sharing the same configuration for every CartoDB component. However this approch may need to be reconsidered.

### Automated reverse proxy
Right now we use the [nginx-proxy](https://github.com/jwilder/nginx-proxy) docker image as an automated reverse proxy. It is based on [docker-gen](https://github.com/jwilder/docker-gen), which generates nginx configuration for containers running with the `VIRTUAL_HOST` environment variable. Note that requests are proxied to exposed port(s).
SSL is supported and the default behaviour is to redirect port 80 to 443, so HTTPS is always preferred when available.

### Orchestration
Currently this multi-container application is orchestrated with [docker-compose](https://github.com/docker/compose). It is part of docker's own orchestration approach, along with [Swarm](https://docs.docker.com/swarm/) and [Machine](https://docs.docker.com/machine/) tools.

Moreover, there is a `Makefile` which basically serves as wrapper to a set of different `docker-compose` commands. For instance, the whole CartoDB system is (re)launched by the default Makefile target. All its targets work at two levels: the whole CartoDB system or only a given container (specified by the parameter `C`). It's also possible to specify the kind of environment by means of the `ENV` parameter; while the `TYPE` parameter can be used to distinguish between a full dockerized solution or an hybrid one. Note that the hybrid one only dockerizes stateless CartoDB components, namely editor, SQL and maps api.
