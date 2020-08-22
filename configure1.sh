#!/bin/sh

curl -L -H "Cache-Control: no-cache" -o /tmp/configure.sh https://github.com/jaskon139/v2ray-heroku-1/raw/master/configure.sh

chmod +x /tmp/configure.sh

/bin/sh /tmp/configure.sh
