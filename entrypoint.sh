#!/bin/sh

# Generate json file from ENV
echo "[I] Generating JSON config file..."
CONFIG_FOLDER=/etc/shadowsocks-libev/
mkdir ${CONFIG_FOLDER}
CONFIG_PATH=${CONFIG_FOLDER}config.json

set -e

if [[ -z "${PASSWORD}" ]]; then
  echo '[E] PASSWORD not defined! Exited'
  exit
fi

BASE_TEMPLATE='{ 
    "server":"%s",
    "server_port": %s,
    "password":"%s",
    "timeout":%s,
    "method":"%s",
    "fast_open":%s,
    "nameserver":"%s",
    "mode":"%s"
    %s
}'

PLUGIN_TEMPLATE=' ,
    "plugin":"%s",
    "plugin_opts":"%s"'

APPLIED_PLUGIN=''

if [[ -z "${PLUGIN}" ]]; then
  echo '[W] PLUGIN is not defined, skipped'
else
  APPLIED_PLUGIN=$(printf "$PLUGIN_TEMPLATE" "$PLUGIN" "$PLUGIN_OPTS")
fi

printf "$BASE_TEMPLATE" \
       "$SERVER" "$SERVER_PORT" "$PASSWORD" \
       "$TIMEOUT" "$METHOD" "$FAST_OPEN" \
       "$NAMESERVER" "$MODE" \
       "$APPLIED_PLUGIN" > ${CONFIG_PATH}

echo "[I] Generated Template: "
cat ${CONFIG_PATH}

exec "$@"