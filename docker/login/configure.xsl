<?xml version="1.0" encoding="UTF-8"?>

<!--
  Copyright (C) 2015 Stichting Akvo (Akvo Foundation)

  This file is part of Akvo Login.

  Akvo Login is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public licence as
  published by the Free Software Foundation, either version 3 of the
  licence.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public licence included below for more details.

  The full licence text is available at <http://www.gnu.org/licenses/agpl.html>.
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ds="urn:jboss:domain:datasources:2.0"
                xmlns:ispn="urn:jboss:domain:infinispan:2.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="//ds:subsystem/ds:datasources/ds:datasource[@jndi-name='java:jboss/datasources/KeycloakDS']">
    <datasource jndi-name="java:jboss/datasources/KeycloakDS" enabled="true" use-java-context="true" pool-name="KeycloakDS" use-ccm="true">
      <connection-url>jdbc:postgresql://${env.PSQL_PORT}:${env.PSQL_PORT:5432}/${env.PSQL_DB:keycloak}</connection-url>
      <driver>postgresql</driver>
      <security>
        <user-name>${env.PSQL_USERNAME}</user-name>
        <password>${env.PSQL_PASSWORD}</password>
      </security>
      <validation>
        <check-valid-connection-sql>SELECT 1</check-valid-connection-sql>
        <background-validation>true</background-validation>
        <background-validation-millis>60000</background-validation-millis>
      </validation>
      <pool>
        <flush-strategy>IdleConnections</flush-strategy>
      </pool>
    </datasource>
  </xsl:template>

  <xsl:template match="//ds:subsystem/ds:datasources/ds:drivers">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
        <driver name="postgresql" module="org.postgresql.jdbc">
          <xa-datasource-class>org.postgresql.xa.PGXADataSource</xa-datasource-class>
        </driver>
     </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
