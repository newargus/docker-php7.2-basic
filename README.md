# docker-php7.2-basic

# Docker Template
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/newargus/php7.2-basic)](https://hub.docker.com/r/newargus/php7.2-basic)
[![Docker Pulls](https://img.shields.io/docker/pulls/newargus/php7.2-basic)](https://hub.docker.com/r/newargus/php7.2-basic)
[![GitHub](https://img.shields.io/github/license/newargus/docker-php7.2-basic)](./LICENSE)

A self-made image for testing prupose, to learn CI github process inspired from:

* Scripts of [nicholaswilde/docker-shiori](https://github.com/nicholaswilde/docker-leantime)


## Architectures

* [x] `arm64`
* [x] `amd64`

## Dependencies

* mysql (optional)

## Usage

### docker cli

```bash
$ docker run -d \
  --name=php7.2-basic \
  -e TZ=America/Los_Angeles `# optional` \
  -p 80:80 \
  --restart unless-stopped \
  newargus/php7.2-basic
```
