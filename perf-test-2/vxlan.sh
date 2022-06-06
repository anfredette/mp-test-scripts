#!/bin/bash

. ./config.sh

if [ $SUCCESS == "FALSE" ]; then
    echo "ERROR: Unsupported host: $(hostname)"
    exit
fi

if [[ $(hostname) == $SERVER1_NAME || $(hostname) == $SERVER2_NAME || $(hostname) == $SERVER3_NAME || $(hostname) == $SERVER4_NAME ]]; then

  # Enable L4 ECMP hashing
  sudo sysctl net.ipv4.fib_multipath_hash_policy=1

  # Add VXLAN Tunnel
  sudo ip link add $VXLAN_DEV type vxlan id $VXLAN_VNI dev $ETH_DEV dstport $VXLAN_PORT
  sudo bridge fdb append to 00:00:00:00:00:00 dst $NEXT_HOP_1 dev $VXLAN_DEV
  sudo ip addr add $VXLAN_IP/24 dev $VXLAN_DEV
  sudo ip link set up dev $VXLAN_DEV

  # Setup multipath routes to get to other containers
  sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_1 via $NEXT_HOP_1_VXLAN_IP dev $VXLAN_DEV
  sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_2 via $NEXT_HOP_1_VXLAN_IP dev $VXLAN_DEV

elif [[ $(hostname) == $GATEWAY1_NAME || $(hostname) == $GATEWAY2_NAME ]]; then

  # Add VXLAN Tunnel
  sudo ip link add $VXLAN_DEV type vxlan id $VXLAN_VNI dev $ETH_DEV dstport $VXLAN_PORT
  sudo bridge fdb append to 00:00:00:00:00:00 dst $SERVER1_IP dev $VXLAN_DEV
  sudo bridge fdb append to 00:00:00:00:00:00 dst $SERVER2_IP dev $VXLAN_DEV
  sudo bridge fdb append to 00:00:00:00:00:00 dst $SERVER3_IP dev $VXLAN_DEV
  sudo bridge fdb append to 00:00:00:00:00:00 dst $SERVER4_IP dev $VXLAN_DEV
  sudo ip addr add $VXLAN_IP/24 dev $VXLAN_DEV
  sudo ip link set up dev $VXLAN_DEV

  # Change routes to use VXLAN tunnels
  sudo ip route replace $SERVER1_CONTAINER_SUBNET via $SERVER1_VXLAN_IP dev $VXLAN_DEV
  sudo ip route replace $SERVER2_CONTAINER_SUBNET via $SERVER2_VXLAN_IP dev $VXLAN_DEV
  sudo ip route replace $SERVER3_CONTAINER_SUBNET via $SERVER3_VXLAN_IP dev $VXLAN_DEV
  sudo ip route replace $SERVER4_CONTAINER_SUBNET via $SERVER4_VXLAN_IP dev $VXLAN_DEV

else
  echo "Error, invalid hostname: $(hostname)"
fi
