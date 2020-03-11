#!/bin/sh
#
# This is a Shell script for shadowsocks-libev based alpine with Docker image
# 
# Copyright (C) 2019 - 2020 NeverBehave <i@never.pet>
#
# Reference URL:
# https://github.com/shadowsocks/shadowsocks-libev
# https://github.com/shadowsocks/simple-obfs
# https://github.com/shadowsocks/v2ray-plugin
# https://github.com/teddysun/shadowsocks_install

GITHUB_API=https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest 
DOWNLOAD_URL=https://github.com/shadowsocks/v2ray-plugin/releases/download/

TAG_NAME=$(curl ${GITHUB_API} | grep -oP '"tag_name": "\K(.*)(?=")')
echo "Current V2ray Tag: ${TAG_NAME}"

# @TODO Identify OS version, assume linux for now...

PLATFORM=$1
echo ${PLATFORM}
if [ -z "$PLATFORM" ]; then
    ARCH="amd64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="386"
            ;;
        linux/amd64)
            ARCH="amd64"
            ;;
        linux/arm/v6)
            ARCH=""
            ;;
        linux/arm/v7)
            ARCH=""
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64"
            ;;
        linux/mips)
            ARCH="mips"
            ;;
        linux/s390x)
            ARCH=""
            ;;
        *)
            ARCH=""
            ;;
    esac
fi

[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1
# Download v2ray-plugin binary file
V2RAY_PLUGIN_DOWNLOAD_NAME="v2ray-plugin-linux-${ARCH}-${TAG_NAME}.tar.gz"
V2RAY_FILE_NAME="v2ray-plugin_linux_${ARCH}"
V2RAY_DOWNLOAD_URL="${DOWNLOAD_URL}${TAG_NAME}/${V2RAY_PLUGIN_DOWNLOAD_NAME}"
echo "Downloading v2ray-plugin binary file: ${V2RAY_PLUGIN_DOWNLOAD_NAME} From ${V2RAY_DOWNLOAD_URL}"
wget -P /tmp ${V2RAY_DOWNLOAD_URL} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download v2ray-plugin binary file: ${V2RAY_FILE_NAME}" && exit 1
fi
tar -xvf "/tmp/${V2RAY_PLUGIN_DOWNLOAD_NAME}"
mv "${V2RAY_FILE_NAME}" /usr/bin/v2ray-plugin
chmod +x /usr/bin/v2ray-plugin
echo "Download v2ray-plugin binary file: ${V2RAY_FILE_NAME} completed"
