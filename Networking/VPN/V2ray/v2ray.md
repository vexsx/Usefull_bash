To install V2Ray on Ubuntu and generate a config file, follow these steps:

1. Update your system's package list:

```
sudo apt update
```

2. Install the required dependencies:

```
sudo apt install -y curl unzip
```

3. Download and install V2Ray using the following commands:

```
curl -Lso /usr/local/bin/v2ray https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
sudo unzip /usr/local/bin/v2ray
sudo chmod +x /usr/local/bin/v2ray
```

4. Create a new V2Ray configuration directory:

```
mkdir -p ~/.v2ray/
```

5. Generate a new config file using a template. Replace `your_uuid_here` with your actual UUID (you can generate one at https://www.uuidgenerator.net/):

```
cat > ~/.v2ray/config.json <<EOF
{
    "inbounds": [
        {
            "port": 10000,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "your_uuid_here",
                        "level": 0,
                        "alterId": 0
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ],
    "routing": {
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    }
}
EOF
```

6. Download and install geoip and dat files:

```
curl -o ~/.v2ray/geoip.dat https://raw.githubusercontent.com/v2fly/v2ray-core/master/release/geoip.dat
curl -o ~/.v2ray/geosite.dat https://raw.githubusercontent.com/v2fly/v2ray-core/master/release/geosite.dat
```

7. Start the V2Ray service:

```
v2ray -config=~/.v2ray/config.json
```

Your V2Ray server is now running with the given configuration. You can create a V2Ray client configuration based on this server configuration to connect to it.

If you want to run V2Ray as a system service, follow these additional steps:

1. Create a systemd service file:

```
sudo nano /etc/systemd/system/v2ray.service
```

2. Add the following content to the file:

```
[Unit]
Description=V2Ray Service
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/v2ray -config=/root/.v2ray/config.json
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

3. Save and close the file.

4. Enable and start the V2Ray service:

```
sudo systemctl enable v2ray
sudo systemctl start v2ray
```

5. Check the status of the V2Ray service:

```
sudo systemctl status v2ray
```

Now, V2Ray will run as a system service and start automatically when your system boots.