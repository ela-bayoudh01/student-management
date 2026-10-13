# Image de base : JRE 17 uniquement (pas de JDK, pas de Maven)
FROM eclipse-temurin:17-jre

# Répertoire de travail
WORKDIR /app

# Copie du jar produit par Maven, renommé app.jar
COPY target/*.jar app.jar

# Port d'écoute de l'application (server.port=8089)
EXPOSE 8089

# Commande de démarrage (forme exec)
ENTRYPOINT ["java", "-jar", "app.jar"]