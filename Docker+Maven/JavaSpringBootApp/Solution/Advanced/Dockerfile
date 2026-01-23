FROM maven:3.8-eclipse-temurin-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:11-jre
WORKDIR /app
COPY --from=build /app/target/warehouse-api-1.0.0.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
