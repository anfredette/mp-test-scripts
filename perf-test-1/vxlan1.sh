#!/bin/bash

. ./config.sh

if [ $SUCCESS == "FALSE" ]; then
    echo "ERROR: Unsupported host: $(hostname)"
    exit
fi

# Add VXLAN Tunnel and set up routes
sudo ip link add $VXLAN_DEV type vxlan id $VXLAN_VNI dev $ETH_DEV dstport $VXLAN_PORT
sudo bridge fdb append to 00:00:00:00:00:00 dst $OTHER_SERVER_VXLAN_NODE_1 dev $VXLAN_DEV
sudo ip addr add $VXLAN_IP/24 dev $VXLAN_DEV
sudo ip link set up dev $VXLAN_DEV
sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_1 via $OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_1 dev $VXLAN_DEV
