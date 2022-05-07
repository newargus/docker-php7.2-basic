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


## PHP Modules enaabled

[PHP Modules]  # Result of shell command : php -m
bcmath
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
igbinary
intl
json
ldap
libxml
mbstring
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
SimpleXML
snmp
sodium
SPL
sqlite3
standard
tokenizer
xdebug
xml
xmlreader
xmlwriter
zip
zlib

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
