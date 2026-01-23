# Easy to remember but mention to interviewer that
# you would never use latest in PROD:
FROM maven 

WORKDIR /app
COPY warehouse-api-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]