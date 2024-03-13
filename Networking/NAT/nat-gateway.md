To share a single static IP address among multiple servers, you can use a technique called "IP masquerading" or "Network Address Translation (NAT)." Here's a general overview of how you can set this up:

1. Choose one server to act as the gateway or router. This server will have the static IP address assigned to it and will be responsible for routing traffic to and from the other servers.

2. Configure the gateway server to enable IP forwarding. This allows the server to forward packets between the internal network and the external network.

   - On Linux, you can enable IP forwarding by setting the following system parameter:
     ```
     sudo sysctl -w net.ipv4.ip_forward=1
     ```

   - To make this change permanent, add the following line to the `/etc/sysctl.conf` file:
     ```
     net.ipv4.ip_forward=1
     ```

3. Set up NAT on the gateway server using iptables. This will translate the private IP addresses of the internal servers to the public static IP address when the packets leave the gateway server.

   - Example iptables command to enable NAT:
     ```
     sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
     ```
     Replace `eth0` with the network interface connected to the external network.

4. Configure the other servers to use private IP addresses within the same subnet. These servers will communicate with the gateway server using their private IP addresses.

5. Set the default gateway on the other servers to the private IP address of the gateway server. This ensures that all outbound traffic from these servers is routed through the gateway server.

6. Configure port forwarding on the gateway server if you need to expose specific services running on the internal servers to the external network. This allows incoming traffic to be directed to the appropriate server based on the port number.

   - Example iptables command to forward incoming HTTP traffic (port 80) to an internal server with IP address 192.168.0.10:
     ```
     sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.0.10:80
     ```

7. Test the setup by accessing the services running on the internal servers using the public static IP address and the appropriate port numbers.

Keep in mind that this is a simplified explanation, and the specific commands and configurations may vary depending on your operating system and network setup. It's important to properly secure your servers and configure firewall rules to allow only necessary traffic.

Additionally, if you have a large number of servers or require more advanced features, you may consider using a dedicated load balancer or reverse proxy solution like HAProxy or Nginx to distribute traffic among the servers.