FROM golang:alpine AS build-forego

RUN apk add --no-cache git openssh

WORKDIR /app

RUN git clone https://github.com/wahyd4/forego.git \
    && cd forego \
    && git checkout 20180216151118 \
    && go mod init \
    && go mod vendor \
    && go mod download \
    && go build -o forego \
    && chmod +x forego

FROM ubuntu:20.04 as Selector-setup

# - Setting up tzdata configuration
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

# - Configuring Environment
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "LANG=en_US.UTF-8" >> /etc/environment
RUN echo "NODE_ENV=development" >> /etc/environment
RUN more "/etc/environment"

RUN apt-get update
RUN apt-get install curl htop git zip nano ncdu build-essential chrpath libssl-dev libxft-dev pkg-config glib2.0-dev libexpat1-dev gobject-introspection python-gi-dev apt-transport-https libgirepository1.0-dev libtiff5-dev libjpeg-turbo8-dev libgsf-1-dev fail2ban nginx -y

# - Installing php
RUN apt-get install --yes software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt -y install php7.4

# - Installing node
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get install --yes nodejs

RUN node -v
RUN npm -v
RUN php -v

#FROM alpine:edge

LABEL AUTHOR=Junv<wahyd4@gmail.com>

WORKDIR /app

ENV ENABLE_AUTH=false
ENV ENABLE_RCLONE=true
ENV DOMAIN=:80
ENV USERNAME=user
ENV PASSWORD=password
ENV PUID=1000
ENV PGID=1000
ENV CADDYPATH=/app
ENV RCLONE_CONFIG=/app/conf/rclone.conf
ENV XDG_DATA_HOME=/app/.caddy/data
ENV XDG_CONFIG_HOME=/app/.caddy/config
ENV RCLONE_CONFIG_BASE64=""

RUN mkdir /app/conf/
RUN chmod -R 755 /app/conf/
RUN mkdir /app/Selector/

ADD install.sh caddy.sh Procfile init.sh start.sh rclone.sh selector.sh /app/
RUN chmod a+x /app/selector.sh
ADD Selector/index.html Selector/upload.js Selector/process.php /app/Selector/
ADD HerokuCaddyfile /usr/local/caddy/

COPY --from=build-forego /app/forego/forego /app

RUN ./install.sh

RUN rm ./install.sh

EXPOSE 80 443

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f http://localhost || exit 1

CMD ["./start.sh"]
