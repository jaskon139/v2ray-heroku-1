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
    "stats": {},
    "api": {
        "services": [
            "StatsService"
        ],
        "tag": "api"
    },
    "routing": {
        "strategy": "rules",
        "settings": {
            "rules": [
                {
                    "inboundTag": [
                        "api"
                    ],
                    "type": "field",
                    "outboundTag": "api"
                }
            ]
        }
    },
    "inbounds": [
        {
            "streamSettings": {
                "wsSettings": {
                    "path": "/ray"
                },
                "network": "ws",
                "kcpSettings": {
                    "uplinkCapacity": 5,
                    "downlinkCapacity": 20,
                    "readBufferSize": 1,
                    "mtu": 1350,
                    "header": {
                        "type": "none"
                    },
                    "tti": 20,
                    "congestion": false,
                    "writeBufferSize": 1
                },
                "tcpSettings": {
                    "header": {
                        "type": "none",
                        "response": {
                            "status": "200",
                            "headers": {
                                "Transfer-Encoding": [
                                    "chunked"
                                ],
                                "Connection": [
                                    "keep-alive"
                                ],
                                "Content-Type": [
                                    "application/octet-stream",
                                    "application/x-msdownload",
                                    "text/html",
                                    "application/x-shockwave-flash"
                                ],
                                "Pragma": "no-cache"
                            },
                            "reason": "OK",
                            "version": "1.1"
                        }
                    }
                }
            },
            "protocol": "vmess",
            "port": "$PORT",
            "settings": {
                "clients": [
                    {
                        "alterId": 64,
                        "level": 0,
                        "id": "$UUID"
                    }
                ]
            }
        },
        {
            "tag": "api",
            "settings": {
                "address": "127.0.0.1"
            },
            "protocol": "dokodemo-door",
            "port": 5001,
            "listen": "127.0.0.1"
        }
    ],
    "policy": {
        "levels": {
            "0": {
                "statsUserUplink": true,
                "statsUserDownlink": true
            }
        },
        "system": {
            "statsInboundDownlink": true,
            "statsInboundUplink": true
        }
    },
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {}
        },
        {
            "tag": "blocked",
            "protocol": "blackhole",
            "settings": {}
        }
    ]
}
EOF

# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
