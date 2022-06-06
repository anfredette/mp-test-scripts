#!/bin/bash

. ./config.sh

if [ $SUCCESS == "FALSE" ]; then
    echo "ERROR: Unsupported host: $(hostname)"
    exit
fi

if [[ $(hostname) == $SERVER1_NAME || $(hostname) == $SERVER2_NAME || $(hostname) == $SERVER3_NAME || $(hostname) == $SERVER4_NAME ]]; then

  # Enable L4 ECMP hashing
  # sudo sysctl net.ipv4.fib_multipath_hash_policy=1

  # Add VXLAN Tunnel
  # sudo ip link add $VXLAN_DEV type vxlan id $VXLAN_VNI dev $ETH_DEV dstport $VXLAN_PORT
  # sudo bridge fdb append to 00:00:00:00:00:00 dst $NEXT_HOP_1 dev $VXLAN_DEV
  sudo bridge fdb append to 00:00:00:00:00:00 dst $NEXT_HOP_2 dev $VXLAN_DEV
  # sudo ip addr add $VXLAN_IP/24 dev $VXLAN_DEV
  # sudo ip link set up dev $VXLAN_DEV

  # Setup multipath routes to get to other containers
  sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_1 \
    nexthop via $NEXT_HOP_1_VXLAN_IP dev $VXLAN_DEV  \
    nexthop via $NEXT_HOP_2_VXLAN_IP dev $VXLAN_DEV
  sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_2 \
    nexthop via $NEXT_HOP_1_VXLAN_IP dev $VXLAN_DEV  \
    nexthop via $NEXT_HOP_2_VXLAN_IP dev $VXLAN_DEV

elif [[ $(hostname) == $GATEWAY1_NAME || $(hostname) == $GATEWAY2_NAME ]]; then

echo "On $(hostname).  No change necessary"
else
  echo "Error, invalid hostname: $(hostname)"
fi
