#! /bin/sh

# Generate json file from ENV

CONFIG_PATH=/etc/shadowsocks-libev/config.json

if [[ -z "${PASSWORD}" ]]; then
  echo '[E] PASSWORD not defined! Exited'
  exit
fi

read -r -d '' BASE_TEMPLATE << EOM
{ 
    "server":"%s",
    "server_port": %s,
    "password":"%s",
    "timeout":%s,
    "method":"%s",
    "fast_open":%s,
    "nameserver":"%s",
    "mode":"%s"
    %s
}
EOM

read -r -d '' PLUGIN_TEMPLATE << EOM
    ,
    "plugin":"%s",
    "plugin_opts":"%s"
EOM

APPLIED_PLUGIN=''

if [[ -z "${PLUGIN}" ]]; then
  echo '[W] PLUGIN is not defined, skipped'
else
  printf "$PLUGIN_TEMPLATE" "$PLUGIN" "$PLUGIN_OPTS" > APPLIED_PLUGIN
fi

printf "$BASE_TEMPLATE" \
       "$SERVER" "$SERVER_PORT" "$PASSWORD" \
       "$TIMEOUT" "$METHOD" "$FAST_OPEN" \
       "$NAMESEREVR" "$MODE" \
       "$APPLIED_PLUGIN" > ${CONFIG_PATH}

echo "[I] Generated Template: "
cat ${CONFIG_PATH}

exec "$@"