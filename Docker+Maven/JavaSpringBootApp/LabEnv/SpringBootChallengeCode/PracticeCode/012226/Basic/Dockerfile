FROM eclipse-temurin:11-alpine-3.20
WORKDIR /app/
COPY warehouse-api-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]