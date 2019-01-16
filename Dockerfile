FROM openjdk:8-jre-alpine
WORKDIR /
ADD dropwizard-example-0.0.1-SNAPSHOT.jar dropwizard-example-0.0.1-SNAPSHOT.jar
ADD mysql.yml mysql.yml
EXPOSE 8080
CMD java -jar dropwizard-example-0.0.1-SNAPSHOT.jar server mysql.yml
