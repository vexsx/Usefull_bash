#!/usr/bin/python3
"""Get Redis master IP. Used by ansible to update redisdb hosts."""

import argparse
import socket

import common_redis as common


def get_current_master(cluster, db, subcluster):
    """Get current master."""
    redis_conf = f'/opt/redis/{db}/redis.conf'

    with open(redis_conf, 'r') as conf:
        lines = conf.readlines()

    password = None
    sentinel_port = None

    for line in lines:
        if 'requirepass' in line:
            password = line.split(' ')[1].rstrip()
        elif 'port' == line.split(' ')[0]:
            sentinel_port = int(line.split(' ')[1]) - 20000

    redis_obj = common.Redis(False, verbose=False, timeout=1)
    hostname = socket.getfqdn()

    # Query sentinel
    master_ip = None

    for i in range(1, 4):
        host = f"{subcluster}"
        master_ip = redis_obj.run_command(host, sentinel_port, password, 'SENTINEL GET-MASTER-ADDR-BY-NAME default')
        if master_ip:
            master_ip = master_ip[0].decode()
            break

    if not master_ip:
        # Return the IP of the first db, usually srv1.
        master_ip = socket.gethostbyname(f"{subcluster}")

    print(master_ip)


def main():
    """Main."""
    parser = argparse.ArgumentParser(description='Get Redis master IP')
    parser.add_argument('--cluster', '-c', help='cluster name', required=True)
    parser.add_argument('--subcluster', '-s', help='redis db subcluster', required=True)
    parser.add_argument('--db', '-d', help='redis db name', required=True)
    args = parser.parse_args()

    try:
        get_current_master(args.cluster, args.db, args.subcluster)
    except Exception as e:
        print(f"An error occurred: {str(e)}")


if __name__ == '__main__':
    main()