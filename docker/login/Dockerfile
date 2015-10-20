# Copyright (C) 2015 Stichting Akvo (Akvo Foundation)
#
# This file is part of Akvo Login.
#
# Akvo Login is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public licence as
# published by the Free Software Foundation, either version 3 of the
# licence.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public licence included below for more details.
#
# The full licence text is available at <http://www.gnu.org/licenses/agpl.html>.

FROM jboss/keycloak

MAINTAINER Akvo Foundation

# Environment variables
ENV AKVO_THEME_FILE      http://files.support.akvo-ops.org/keycloak/themes.tar.gz
ENV KEYCLOAK_DIR         /opt/jboss/keycloak
ENV KEYCLOAK_CONFIG_FILE $KEYCLOAK_DIR/standalone/configuration/standalone.xml
ENV PSQL_DRIVER_DIR      $KEYCLOAK_DIR/modules/system/layers/base/org/postgresql/jdbc/main
ENV PSQL_DRIVER_VERSION  9.4-1204-jdbc42
ENV SAXON                java -jar /usr/share/java/saxon.jar

# Install Akvo theme
RUN cd $KEYCLOAK_DIR
RUN curl -L $AKVO_THEME_FILE | tar xz

# Install PostgreSQL JDBC driver
RUN mkdir -p $PSQL_DRIVER_DIR
RUN cd $PSQL_DRIVER_DIR
RUN curl -L https://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/$PSQL_DRIVER_VERSION/$PSQL_DRIVER_VERSION.jar
ADD module.xml $PSQL_DRIVER_DIR

# Post-installation configuration
ADD configure.xsl $KEYCLOAK_DIR
RUN $SAXON -s:$KEYCLOAK_CONFIG_FILE -xsl:$KEYCLOAK_DIR/configure.xsl -o:$KEYCLOAK_CONFIG_FILE
