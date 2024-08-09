# Use the official MongoDB image as the base image
FROM mongo:8.0.0-rc13 AS base

ARG DB_URL="mongodb+srv://localhost/api"
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
  apt-get install -y wget gnupg && \
  wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.lists

# Install the MongoDB tools to restore the database
RUN apt-get update && \
  apt-get install -y mongodb-org-tools

# Clean up the apt cache to reduce image size
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*
