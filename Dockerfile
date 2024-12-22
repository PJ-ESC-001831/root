FROM ubuntu:24.04

# Install git and other dependencies
RUN apt-get update && \
  apt-get install -y git \
  curl \
  npm \
  gnupg \
  make \
  build-essential \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /workspace