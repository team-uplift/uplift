-- Run this script first to create the schema if necessary, and add the rds_uplift user
CREATE SCHEMA IF NOT EXISTS uplift;

CREATE USER IF NOT EXISTS rds_uplift IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, EVENT, SHOW VIEW, TRIGGER ON uplift.* TO rds_uplift;
ALTER USER 'rds_uplift'@'%' REQUIRE SSL;
