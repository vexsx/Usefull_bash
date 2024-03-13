#!/bin/bash

set -e 


getway() {
  echo "Be aware this allows the server to forward packets between the internal network and the external network."
  sleep 7 &
  sudo sysctl -w net.ipv4.ip_forward=1
  echo "net.ipv4.ip_forward=1" |  tee -a /etc/sysctl.conf > /dev/null
  echo "Setting up NAT on the gateway server using iptables"
  sleep 7 &
  ifconfig
  read -p "Input the name of the interface that you assigned a public IP (example: ens33): " interface
  ## iptables
  sudo iptables -t nat -A POSTROUTING -o $interface -j MASQUERADE
  echo "Configure the other servers to use private IP addresses within the same subnet. These servers will communicate with the gateway server using their private IP addresses."
  echo "Set the default gateway on the other servers to the private IP address of the gateway server. This ensures that all outbound traffic from these servers is routed through the gateway server."
  read -p "Press any key to continue..." -n1 -s
  echo
  read -p "How many servers or ports do you want to configure: " serverNUM

  for ((i=1; i<=$serverNUM; i++)); do
     echo "Processing server/port $i"
     read -p "Which port do you want to forward? (example: 80): " port
     read -p "Input an internal server with IP address (example: 192.168.0.10:80): " server
     sudo iptables -t nat -A PREROUTING -p tcp --dport $port -j DNAT --to-destination $server
  done

  echo "Keep in mind that this is a simplified explanation, and the specific commands and configurations may vary depending on your operating system and network setup. It's important to properly secure your servers and configure firewall rules to allow only necessary traffic."
  echo "Additionally, if you have a large number of servers or require more advanced features, you may consider using a dedicated load balancer or reverse proxy solution like HAProxy or Nginx to distribute traffic among the servers."
  sleep 6 &
}


rproxy(){

    # Check and install Nginx
    if ! command -v nginx &> /dev/null
    then
        echo "Nginx is not installed. Installing Nginx..."
        sudo apt update && sudo apt install -y nginx
    else
        echo "Nginx is already installed."
    fi
    echo "http {
    upstream backend1 {
        server 192.168.1.101;
    }
    server {
        listen 80;
        server_name www.example1.com;

        location / {
            proxy_pass http://backend1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}" > /etc/nginx/conf.d/nat.conf
    
    # Configure as DNS server
    echo "Would you like to make the server a DNS server to help internal servers?"
    echo "1) Yes"
    echo "2) No"
    read -p "Select: " -n 1 choice
    
    if [ "$choice" == "1" ]; then
        echo "You selected yes"
        sudo systemctl disable systemd-resolved && sudo systemctl stop systemd-resolved
        sudo rm -f /etc/resolv.conf
        echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf > /dev/null
        echo "
        options {
            directory \"/var/cache/bind\";
            
            // If there is a firewall between you and nameservers you want
            // to talk to, you may need to fix the firewall to allow multiple
            // ports to talk. See http://www.kb.cert.org/vuls/id/800113

            // If your ISP provided one or more IP addresses for stable
            // nameservers, you probably want to use them as forwarders.
            // Uncomment the following block, and insert the addresses replacing
            // the all-0's placeholder.

            forwarders {
                178.22.122.100;
                185.51.200.2;
            };
            recursion yes;
            allow-recursion { any; };
            forward only;

            //========================================================================
            // If BIND logs error messages about the root key being expired,
            // you will need to update your keys. See https://www.isc.org/bind-keys
            //========================================================================
            dnssec-validation auto;

            listen-on-v6 { any; };
        };
        " >  /etc/bind/named.conf.options

        echo "Configure your DNS records to point to the static IP address. If you're serving different websites, you can use subdomains or different domain names that all point to the same IP."
        sleep 5 &
    elif [ "$choice" == "2" ]; then
        echo "You selected no"
    else
        echo "Invalid selection. Please choose 1 or 2."
    fi
}

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "choose NAT installer options : "
echo "1) linux as gateway "
echo "2) set-up revers proxy (nginx) "

read -p "select : " -n1 choice


if [ $choice == "1" ]; then
    echo "You selected linux as gateway."
    getway
elif [ $choice == "2" ]; then
    echo "You selected set-up reverse proxy (nginx)."
    rproxy
else
    echo "Invalid selection. Please choose 1 or 2."
fi


echo "for adding manually more servers in iptables" > $(pwd)/nat-helper
echo "sudo iptables -t nat -A PREROUTING -p tcp --dport $port -j DNAT --to-destination $server" >> $(pwd)/nat-helper
echo "--------------------------------------------------------------------------------------------------" >> $(pwd)/nat-helper
echo "for adding manually more servers in nginx" >> $(pwd)/nat-helper 
echo just edit config file in /etc/nginx/conf.d/NAT.conf" >> $(pwd)/nat-helper 


echo "Set up of nat is seccessfuly done!"