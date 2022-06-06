#!/bin/bash

. ./config.sh

if [ $SUCCESS == "FALSE" ]; then
    echo "ERROR: Unsupported host: $(hostname)"
    exit
fi

echo "Disabling firewalld (if enabled)"
sudo systemctl stop firewalld
sudo systemctl disable firewalld

if [[ $(hostname) == $SERVER1_NAME || $(hostname) == $SERVER2_NAME || $(hostname) == $SERVER3_NAME || $(hostname) == $SERVER4_NAME ]]; then
  echo "Creating the namespaces"
  sudo ip netns add $CON1
  
  echo "Creating the veth pairs"
  sudo ip link add veth10 type veth peer name veth11
  
  echo "Adding the veth pairs to the namespaces"
  sudo ip link set veth11 netns $CON1
  
  echo "Configuring the interfaces in the network namespaces with IP address"
  sudo ip netns exec $CON1 ip addr add $CON1_IP/24 dev veth11
  
  echo "Enabling the interfaces inside the network namespaces"
  sudo ip netns exec $CON1 ip link set dev veth11 up
  
  echo "Creating the bridge"
  sudo ip link add name br0 type bridge
  
  echo "Adding the network namespaces interfaces to the bridge"
  sudo ip link set dev veth10 master br0
  
  echo "Assigning the IP address to the bridge"
  sudo ip addr add $BRIDGE_IP/24 dev br0
  
  echo "Enabling the bridge"
  sudo ip link set dev br0 up
  
  echo "Enabling the interfaces connected to the bridge"
  sudo ip link set dev veth10 up
  
  echo "Setting the loopback interfaces in the network namespaces"
  sudo ip netns exec $CON1 ip link set lo up
  
  echo "Setting the default route in the network namespaces"
  sudo ip netns exec $CON1 ip route add default via $BRIDGE_IP dev veth11
  
  # Setup routes to get to other nodes in same cluster
  sudo ip route add $OTHER_SERVER_CONTAINER_SUBNET_1 via $NEXT_HOP_1 dev $ETH_DEV
  sudo ip route add $OTHER_SERVER_CONTAINER_SUBNET_2 via $NEXT_HOP_1 dev $ETH_DEV
  sudo ip route add $OTHER_SERVER_CONTAINER_SUBNET_3 via $OTHER_SERVER_CONTAINER_NEXT_HOP_3 dev $ETH_DEV
  
  echo "Enabling IP forwarding on the node"
  sudo sysctl -w net.ipv4.ip_forward=1
elif [[ $(hostname) == $GATEWAY1_NAME || $(hostname) == $GATEWAY2_NAME ]]; then
  # Setup gateway
  sudo ip route add $SERVER1_CONTAINER_SUBNET via $SERVER1_IP dev $ETH_DEV
  sudo ip route add $SERVER2_CONTAINER_SUBNET via $SERVER2_IP dev $ETH_DEV
  sudo ip route add $SERVER3_CONTAINER_SUBNET via $SERVER3_IP dev $ETH_DEV
  sudo ip route add $SERVER4_CONTAINER_SUBNET via $SERVER4_IP dev $ETH_DEV

  echo "Enabling IP forwarding on the node"
  sudo sysctl -w net.ipv4.ip_forward=1
else
  echo "Error, invalid hostname: $(hostname)"
  exit
fi
