Setting up high availability (HA) for an Nginx load balancer and reverse proxy node with Keepalived involves installing and configuring Keepalived and Nginx on two or more nodes. Here's a general outline of the steps involved:

1. Install Keepalived and Nginx on all nodes that will participate in the HA setup.
2. Configure Nginx as a load balancer and reverse proxy on all nodes. This can involve setting up upstream server blocks, defining server blocks for the virtual IP address that will be shared between the nodes, and configuring any necessary SSL certificates.
3. Configure Keepalived on all nodes. This involves defining a virtual IP address that will be shared between the nodes, setting up health checks to monitor the Nginx service, and configuring priority settings to determine which node should become the active node in the event of a failure.
4. Start the Keepalived service on all nodes.
5. Test the HA setup by intentionally taking down one of the nodes and verifying that the other node takes over as the active node and continues to serve traffic.

Here's an example configuration for Keepalived on two nodes (node1 and node2):

**node1:**
```bash
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 55
    priority 149
    advert_int 1
    unicast_src_ip 192.168.1.1
    unicast_peer {
      192.168.1.2
    }
    authentication {
      auth_type PASS
      auth_pass Q1qaw123
    }

    virtual_ipaddress {
      192.168.1.100/24
  }
  }
```
In this example, both nodes are configured with the same virtual IP address (192.168.1.100), and node1 is configured as the MASTER with a priority of 101, while node2 is configured as the BACKUP with a priority of 100. If node1 fails, node2 will take over as the active node and assume the virtual IP address.



