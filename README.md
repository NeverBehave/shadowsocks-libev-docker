# Shadowsocks-libev Docker Image

基于 Based on: https://github.com/teddysun/shadowsocks_install/tree/master/docker/shadowsocks-libev

## Changes 修改

- 适合于集群使用，通过环境变量生成配置，无需映射文件

    Suitable for cluster/k8s, generating config from environment variables, no volumn mapping required.

- 原`Dockerfile`包含从私人镜像站下载的二进制文件`dl.lamp.sh`，改为从`github`获取

  The origin dockerfile download binary file from private mirror center `dl.lamp.sh`, changed to download from `github`

## Intro 

[shadowsocks-libev][1] is a lightweight secured socks5 proxy for embedded devices and low end boxes.

It is a port of [shadowsocks][2] created by @clowwindy maintained by @madeye and @linusyang.

Based on alpine with latest version [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) and [simple-obfs](https://github.com/shadowsocks/simple-obfs) and [v2ray-plugin](https://github.com/shadowsocks/v2ray-plugin).

Docker images are built for quick deployment in various computing cloud providers.

For more information on docker and containerization technologies, refer to [official document][3].

## Prepare the host

If you need to install docker by yourself, follow the [official installation guide][4].

## Pull the image

```bash
$ docker pull teddysun/shadowsocks-libev
```

This pulls the latest release of shadowsocks-libev.

It can be found at [Docker Hub][5].

## Start a container

Set Environment Variables, check the table below.

 Only required values are enforced or container won't work.

### Environment Variables

| Name        | Accept Value              | Required | Default                |
| ----------- | ------------------------- | -------- | ---------------------- |
| SERVER      | IP Address                |          | 0.0.0.0                |
| SERVER_PORT | Number                    |          | 9000                   |
| PASSWORD    | String                    | True     |                        |
| TIMEOUT     | Number                    |          | 300                    |
| METHOD      | [Check Here][7]           |          | chacha20-ietf-poly1305 |
| FAST_OPEN   | Boolean                   |          | true                   |
| NAMESERVER  | IP Addresses              |          | 8.8.8.8,8.8.4.4        |
| MODE        | tcp, udp, tcp_and_udp     |          | tcp_and_udp            |
| PLUGIN      | obfs-server, v2ray-plugin |          |                        |
| PLUGIN_OPTS | Check Below               |          |                        |

If you want to enable **simple-obfs**, a sample is:

```
-e PLUGIN="obfs-server" -e PLUGIN_OPTS="obfs=tls"
```

If you want to enable **v2ray-plugin**, a sample is:

```
-e PLUGIN="v2ray-plugin" -e PLUGIN_OPTS="server"
```

For more v2ray-plugin configrations please visit [v2ray-plugin usage][6].

This container will generate config based on the `env` provided.

There is an example to start a container that listens on `9000` (both TCP and UDP):

```bash
$ docker run -d -p 9000:9000 -p 9000:9000/udp --name ss-libev --restart=always -e PASSWORD=YOUR_PASSWORD neverbehave/shadowsocks-libev
```

**Warning**: The port number must be same as configuration and opened in firewall.

[1]: https://github.com/shadowsocks/shadowsocks-libev
[2]: https://shadowsocks.org/en/index.html
[3]: https://docs.docker.com/
[4]: https://docs.docker.com/install/
[5]: https://hub.docker.com/r/neverbehave/shadowsocks-libev/
[6]: https://github.com/shadowsocks/v2ray-plugin#usage
[7]: https://github.com/shadowsocks/shadowsocks-libev#usage