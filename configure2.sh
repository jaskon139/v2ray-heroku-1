#!/bin/sh

/sbin/ifconfig

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/v4.27.0/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
	"inbounds": [{
    "port": "$PORT",
		"protocol": "vmess",
		"settings": {
			"clients": [{
        "id": "$UUID",
				"level": 1,
				"alterId": 64
			}]
		},
		"streamSettings": {
			"network": "tcp",
			"tcpSettings": {
				"header": {
					"type": "http",
					"response": {
						"version": "1.1",
						"status": "200",
						"reason": "OK",
						"headers": {
							"Content-Type": ["application/octet-stream",
							"application/x-msdownload",
							"text/html",
							"application/x-shockwave-flash"],
							"Transfer-Encoding": ["chunked"],
							"Connection": ["keep-alive"],
							"Pragma": "no-cache"
						}
					}
				}
			}
		}
	}],
	"outbounds": [{
		"protocol": "freedom",
		"settings": {
			
		}
	}]
}
EOF

# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
