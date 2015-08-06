#!/bin/bash
set -e

# Variables
# --------------------------------------------------------------------

KC_DIR="/opt/keycloak"
KC_RELEASE="1.4.0.Final"
KC_FILE="keycloak-${KC_RELEASE}.tar.gz"
KC_FILE_URL="http://downloads.jboss.org/keycloak/${KC_RELEASE}/${KC_FILE}"

PSQL_DIR="${KC_DIR}/${KC_RELEASE}/modules/system/layers/base/org/postgresql/jdbc/main"
PSQL_RELEASE="9.3-1103-jdbc3"
PSQL_FILE_URL="http://central.maven.org/maven2/org/postgresql/postgresql/${PSQL_RELEASE}/${PSQL_RELEASE}.jar"


# Keycloak
# --------------------------------------------------------------------

wget "${KC_FILE_URL}"
gunzip -c "${KC_FILE}" | tar xf -
rm "${KC_FILE}"


# JDBC3 PostgreSQL driver
# --------------------------------------------------------------------

mkdir -p "${PSQL_DIR}"
cd "${PSQL_DIR}"
wget "${PSQL_FILE_URL}"


# If we get this far, we have succeeded, so prevent another run
# --------------------------------------------------------------------

touch "$KC_DIR/.installed"
