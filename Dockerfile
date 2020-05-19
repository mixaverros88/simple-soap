# Stage 1: download the code of github
FROM alpine/git as downloadSourceCode
WORKDIR /app
RUN git clone https://github.com/mixaverros88/simple-soap

# Stage 2: build the project via maven
FROM maven:3.5-jdk-8-alpine as packageSourceCode
WORKDIR /app
COPY --from=downloadSourceCode /app/simple-soap /app
RUN mvn package

# Stage 3: spin up a tomcat container
FROM tomcat:9.0-alpine
WORKDIR /app
COPY --from=packageSourceCode /app/target/sumws.war /usr/local/tomcat/webapps
# the port which the tomcat is listening inside the container
EXPOSE 8080
# run the tomcat
CMD ["catalina.sh", "run"]