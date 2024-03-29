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

FROM alpine:edge

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
ENV TIMEZONE=Asia/Jakarta

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

CMD ["./start.sh"]
