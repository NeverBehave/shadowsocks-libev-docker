# Dockerfile for shadowsocks-libev based alpine
# Copyright (C) 2018 - 2020 NeverBehave <i@never.pet>
# Reference URL:
# https://github.com/shadowsocks/shadowsocks-libev
# https://github.com/shadowsocks/simple-obfs
# https://github.com/shadowsocks/v2ray-plugin
# https://github.com/teddysun/shadowsocks_install

FROM alpine:latest
LABEL maintainer="NeverBehave <i@never.pet>"

WORKDIR /root
COPY v2ray-plugin.sh /root/v2ray-plugin.sh
COPY entrypoint.sh /root/entrypoint.sh
RUN set -ex \
	&& runDeps="git build-base c-ares-dev autoconf automake libev-dev libtool libsodium-dev linux-headers mbedtls-dev pcre-dev" \
	&& apk add --no-cache --virtual .build-deps ${runDeps} \
	&& mkdir -p /root/obfs \
	&& cd /root/obfs \
	&& git clone --depth=1 https://github.com/shadowsocks/simple-obfs.git . \
	&& git submodule update --init --recursive \
	&& ./autogen.sh \
	&& ./configure --prefix=/usr --disable-documentation \
	&& make install \
	&& mkdir -p /root/libev \
	&& cd /root/libev \
	&& git clone --depth=1 https://github.com/shadowsocks/shadowsocks-libev.git . \
	&& git submodule update --init --recursive \
	&& ./autogen.sh \
	&& ./configure --prefix=/usr --disable-documentation \
	&& make install \
	&& apk add --no-cache \
	tzdata \
	rng-tools \
	ca-certificates \
	$(scanelf --needed --nobanner /usr/bin/ss-* \
	| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
	| xargs -r apk info --installed \
	| sort -u) \
	&& apk del .build-deps \
	&& cd /root \
	&& rm -rf /root/obfs /root/libev \
	&& chmod +x /root/v2ray-plugin.sh \
	&& chmod +x /root/entrypoint.sh \
	&& /root/v2ray-plugin.sh \
	&& rm -f /root/v2ray-plugin.sh

ENV TZ=Asia/Shanghai \
	SERVER=0.0.0.0 \
	SERVER_PORT=9000 \
	TIMEOUT=300 \
	METHOD="chacha20-ietf-poly" \
	FAST_OPEN=true \
	NAMESERVER="8.8.8.8,8.8.4.4" \
	MODE="tcp_and_udp" 

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "ss-server", "-c", "/etc/shadowsocks-libev/config.json" ]
