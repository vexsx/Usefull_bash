Sharing a single static IP address among multiple servers typically involves using a reverse proxy or load balancer. A reverse proxy or load balancer can distribute incoming traffic to the appropriate server based on the request. Here's a general outline of how you might set this up:

1. **Assign the Static IP to a Load Balancer/Reverse Proxy:**
   - Set up a reverse proxy or load balancer on a separate server or device and assign the static IP to this machine. This will be the entry point for all incoming traffic.
   
2. **Configure Internal IP Addresses:**
   - Assign each of your servers a unique internal IP address. These addresses are used within your private network and are not directly accessible from the internet.

3. **Set Up NAT (Network Address Translation):**
   - If you are using a router or firewall, configure NAT rules to ensure that traffic coming to the static IP is forwarded to the correct internal server. However, with a reverse proxy, this might not be necessary as the proxy will handle the traffic routing.

4. **Configure the Reverse Proxy:**
   - Set up the reverse proxy software (such as Nginx, Apache with mod_proxy, or HAProxy) on the server with the static IP.
   - Define rules for routing traffic to the correct server based on the hostname, port, or path. For example, different domains or subdomains can be directed to different backend servers.

5. **DNS Configuration:**
   - Configure your DNS records to point to the static IP address. If you're serving different websites, you can use subdomains or different domain names that all point to the same IP.

6. **SSL/TLS Termination:**
   - If you are using HTTPS, you can handle SSL/TLS termination at the reverse proxy. This means the reverse proxy will decrypt incoming HTTPS connections and then pass on the unencrypted traffic to the appropriate server on your internal network.

7. **Monitoring and Maintenance:**
   - Regularly monitor your setup to ensure it is running smoothly, and maintain your proxy and backend servers to handle the traffic appropriately.

Here are two examples of how you might configure a reverse proxy:

**Nginx Example Configuration:**
```nginx
http {
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
}
```

**HAProxy Example Configuration:**
```haproxy
frontend http_front
    bind *:80
    stats uri /haproxy?stats
    acl host_example1 hdr(host) -i www.example1.com
    acl host_example2 hdr(host) -i www.example2.com
    use_backend backend1_servers if host_example1
    use_backend backend2_servers if host_example2

backend backend1_servers
    server server1 192.168.1.101:80 check

backend backend2_servers
    server server2 192.168.1.102:80 check
```

Remember, the specifics of the setup will depend on your particular environment, the hardware and software you're using, and the traffic patterns you expect. It's important to secure your reverse proxy and backend servers by keeping them updated with the latest security patches and configuring them according to best practices.