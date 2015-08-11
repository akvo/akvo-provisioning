#!/bin/bash
set -e

# Variables
# -----------------------------------------------------------------------------

KC_DIR="/opt/keycloak"
KC_RELEASE="1.4.0.Final"
KC_FILE="keycloak-${KC_RELEASE}.tar.gz"
KC_FILE_URL="http://downloads.jboss.org/keycloak/${KC_RELEASE}/${KC_FILE}"
KC_THEME_FILE="themes.tar.gz"
KC_THEME_URL="http://files.support.akvo-ops.org/keycloak/${KC_THEME_FILE}"

PSQL_DIR="${KC_DIR}/${KC_RELEASE}/\
    modules/system/layers/base/org/postgresql/jdbc/main"
PSQL_RELEASE="9.3-1103-jdbc3"
PSQL_FILE="{PSQL_RELEASE}.jar"
PSQL_FILE_URL="http://central.maven.org/maven2/org/postgresql/postgresql/\
    ${PSQL_RELEASE}/${PSQL_FILE}"


# Keycloak
# -----------------------------------------------------------------------------

# Fetch & unpack Keycloak
wget "${KC_FILE_URL}"
tar xzf "${KC_FILE}"
rm "${KC_FILE}"

# Fetch & unpack our custom theme
cd "${KC_DIR}"
wget "${KC_THEME_URL}"
tar xzf "${KC_THEME_FILE}"
rm "${KC_THEME_FILE}"


# JDBC3 PostgreSQL driver
# -----------------------------------------------------------------------------

mkdir -p "${PSQL_DIR}"
cd "${PSQL_DIR}"
wget "${PSQL_FILE_URL}"


# If we get this far, we have probably succeeded, so prevent another run
# -----------------------------------------------------------------------------

touch "$KC_DIR/.installed"
