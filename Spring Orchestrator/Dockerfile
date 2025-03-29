FROM eclipse-temurin:21-jre
LABEL authors="UpLift Team"

ENV TREMENDOUS_URL="https://testflight.tremendous.com"
ENV TRE_ORDERS_PATH="/api/v2/orders"
ENV FUNDING_SOURCE_ID="BALANCE"
ENV RUNTIME_ENV="prod"
ENV JAVA_TOOL_OPTIONS="--enable-preview"
ENV DB_URL="jdbc:mariadb://cs599-uplift.c0vvml9jbgf1.us-east-1.rds.amazonaws.com:3306/uplift?credentialType=AWS-IAM&useSsl&serverSslCert=classpath:us-east-1-bundle.pem"
ENV DB_USERNAME="rds_uplift"

VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
