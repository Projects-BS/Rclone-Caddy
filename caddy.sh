#! /bin/bash -eu

echo "[INFO] Generate basic auth password for caddy"
PASSWORD_ENCRYPT=$(caddy hash-password -plaintext ${PASSWORD})

case $ENABLE_AUTH in
heroku)
  echo "[INFO] Run Caddy with Heroku mode"
  export CADDY_FILE=/usr/local/caddy/HerokuCaddyfile
  sed -i 's/USERNAME/'"${USERNAME}"'/g' ${CADDY_FILE}
  sed -i 's/PASSWORD_ENCRYPT/'"${PASSWORD_ENCRYPT}"'/g' ${CADDY_FILE}

  sed -i 's/PORT/'"${PORT}"'/g' ${CADDY_FILE}

  ;;
*)
  echo "[INFO] Use caddy without Basic Auth"
  export CADDY_FILE=/usr/local/caddy/Caddyfile
  ;;
esac

/usr/local/bin/caddy run -config ${CADDY_FILE} -adapter=caddyfile
