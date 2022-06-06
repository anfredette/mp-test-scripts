#!/bin/bash

. ./config.sh

if [ $SUCCESS == "FALSE" ]; then
    echo "ERROR: Unsupported host: $(hostname)"
    exit
fi

TUNNEL_TYPE="gre"
TUNNEL_MASK="32"
TUNNEL_DEV_NAME="gre1"

echo "Creating $TUNNEL_TYPE tunnel"
sudo ip link add name $TUNNEL_DEV_NAME type $TUNNEL_TYPE local $LOCAL_TUNNEL_ENDPOINT remote $REMOTE_TUNNEL_ENDPOINT
sudo ip link set $TUNNEL_DEV_NAME up
sudo ip addr add $LOCAL_TUNNEL_IP/$TUNNEL_MASK dev $TUNNEL_DEV_NAME
echo "Add routes"
sudo ip route add $REMOTE_TUNNEL_IP/$TUNNEL_MASK dev $TUNNEL_DEV_NAME
sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_1 dev $TUNNEL_DEV_NAME
