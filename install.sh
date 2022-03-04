#! /bin/sh -eux

echo "[INFO] Set variables for $(arch)"

caddy_version=2.4.6
rclone_version=v1.57.0

case "$(arch)" in

   x86_64)
      platform=linux-amd64
      caddy_file=caddy_${caddy_version}_linux_amd64.tar.gz
      rclone_file=rclone-${rclone_version}-${platform}.zip
     ;;
   armv7l)
     platform=linux-armv7
     caddy_file=caddy_${caddy_version}_linux_armv7.tar.gz
     rclone_file=rclone-${rclone_version}-linux-arm-v7.zip
     ;;

   aarch64)
     platform=linux-arm64
     caddy_file=caddy_${caddy_version}_linux_arm64.tar.gz
     rclone_file=rclone-${rclone_version}-${platform}.zip
     ;;

   *)
     echo "[ERROR] unsupported arch $(arch), exit now"
     exit 1
     ;;
esac

adduser -D -u 1000 junv \
  && apk update \
  && apk add runit shadow wget bash curl openrc gnupg aria2 tar mailcap fuse nano nginx --no-cache \
  && wget -N https://github.com/caddyserver/caddy/releases/download/v${caddy_version}/${caddy_file} \
  && tar -zxf ${caddy_file} \
  && mv caddy /usr/local/bin/ \
  && rm -rf ${caddy_file} \
  && platform=linux-amd64 \
  && curl -O https://downloads.rclone.org/${rclone_version}/${rclone_file} \
  && unzip ${rclone_file} \
  && cd rclone-* \
  && cp rclone /usr/local/bin/ \
  && chown junv:junv /usr/local/bin/rclone \
  && chmod 755 /usr/local/bin/rclone \
  && rm /app/${rclone_file} \
  && rm -rf /app/rclone-* \
  && echo "| php | npm | node |" \
  && apk update && apk upgrade \
  && apk add --update tzdata \
  && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo "${TIMEZONE}" > /etc/timezone \
  && apk --update --no-cache add php8 \
  && php8 --version \
  && php -v \
  && apk add --update nodejs npm \
  && node -v \
  && npm -v \
