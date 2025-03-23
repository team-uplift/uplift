FROM eclipse-temurin:21-jre
LABEL authors="UpLift Team"

VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]