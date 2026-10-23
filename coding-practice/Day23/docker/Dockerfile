cat > coding-practice/Day23/docker/Dockerfile <<'EOF'
# Stage 1: Build the Java application
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /opt/pathnex/java-build

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the application using Tomcat
FROM tomcat:9-jdk17-temurin

WORKDIR /usr/local/tomcat/webapps

COPY --from=builder \
    /opt/pathnex/java-build/target/*.war \
    ./ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
EOF