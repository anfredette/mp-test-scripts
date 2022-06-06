#!/bin/bash

. ./config.sh

if [ $SUCCESS == "FALSE" ]; then
    echo "ERROR: Unsupported host: $(hostname)"
    exit
fi

TUNNEL_TYPE="vxlan"
TUNNEL_MASK="32"
TUNNEL_DEV_NAME="vxlan0"

echo "Creating $TUNNEL_TYPE tunnel"
sudo ip link add name $TUNNEL_DEV_NAME type $TUNNEL_TYPE id $VXLAN_VNI dstport $VXLAN_PORT local $LOCAL_TUNNEL_ENDPOINT remote $REMOTE_TUNNEL_ENDPOINT nolearning
sudo ip link set $TUNNEL_DEV_NAME up
sudo ip addr add $LOCAL_TUNNEL_IP/$TUNNEL_MASK dev $TUNNEL_DEV_NAME
echo "Add routes"
sudo ip route add $REMOTE_TUNNEL_IP/$TUNNEL_MASK dev $TUNNEL_DEV_NAME
sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_1 via $REMOTE_TUNNEL_IP dev $TUNNEL_DEV_NAME
