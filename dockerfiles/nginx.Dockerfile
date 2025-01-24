# Use the official Ubuntu 20.04 base image
FROM ubuntu:20.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for Nginx and Echo Module versions
ENV NGINX_VERSION=1.21.3
ENV ECHO_MODULE_VERSION=0.61

# Install necessary packages for building Nginx
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    zlib1g \
    zlib1g-dev \
    libssl-dev \
    wget \
    curl;

RUN apt-get install -y gnupg \
    libxslt-dev \
    libgd-dev \
    libgeoip-dev \
    linux-headers-generic \
    libperl-dev \
    libedit-dev \
    mercurial \
    bash \
    findutils \
    tar \
    openssl \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for the source files
RUN mkdir -p /usr/src/nginx

# Download and extract Nginx source code
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O nginx.tar.gz && \
    tar -zxC /usr/src/nginx -f nginx.tar.gz

# Download and extract Echo Nginx Module source code
RUN wget https://github.com/openresty/echo-nginx-module/archive/v${ECHO_MODULE_VERSION}.tar.gz -O echo_module.tar.gz && \
    tar -zxC /usr/src/nginx -f echo_module.tar.gz

# Compile and install Nginx with the Echo Module
RUN cd /usr/src/nginx/nginx-${NGINX_VERSION} && \
    ./configure --add-module=../echo-nginx-module-${ECHO_MODULE_VERSION} && \
    make && \
    make install

# Remove unnecessary files to reduce image size
RUN rm -rf /usr/src/nginx && \
    apt-get remove -y build-essential wget curl gnupg && \
    apt-get autoremove -y && \
    apt-get clean

# Set up Nginx configuration directory
COPY ./config/nginx/nginx.conf /usr/local/nginx/conf/nginx.conf
RUN mkdir -p /etc/nginx/conf.d/

# Expose HTTP port
EXPOSE 80

ENV PATH=${PATH}:/usr/local/nginx/sbin/

# Set the default command to run Nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
