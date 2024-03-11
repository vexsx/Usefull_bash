# Ip sets 📐

## 1️⃣ Install ipset using the package manager:
```bash
sudo apt-get update && apt-get install -y ipset
```

## 2️⃣ Create an ipset called myblocklist. This example creates a set for IPv4 addresses. You can adjust the parameters as needed:
```bash
sudo ipset create myblocklist hash:ip family inet hashsize 1024 maxelem 65536

# configure list with iptables 
sudo iptables -A INPUT -m set --match-set myblocklist src -j DROP
```

## 3️⃣ Add IP addresses or ranges to the myblocklist set:
```bash
sudo ipset add myblocklist 192.168.1.100
sudo ipset add myblocklist 192.168.2.0/24
```

## 4️⃣ To save the ipset rules and ensure they persist across reboots, you can use `iptables-persistent`:
```bash
sudo apt-get install -y iptables-persistent
```
## 5️⃣ Save your current ipset rules to a file:
```bash
sudo ipset save > /etc/ipset.conf
```

## 6️⃣ Creat systemd for boot occasion

```bash
cat > /etc/systemd/system/ipset-persistent.service <<EOF
[Unit]
Description=ipset persistent configuration
Before=netfilter-persistent.service

[Service]
Type=oneshot
ExecStart=/sbin/ipset restore -file /etc/ipset.conf
ExecStop=/sbin/ipset save -file /etc/ipset.conf
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the ipset-persistent service
systemctl enable ipset-persistent
systemctl start ipset-persistent
```
