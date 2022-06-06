#!/bin/bash

. ./config.sh

if [ $SUCCESS == "FALSE" ]; then
    echo "ERROR: Unsupported host: $(hostname)"
    exit
fi

sudo bridge fdb append to 00:00:00:00:00:00 dst $OTHER_SERVER_VXLAN_NODE_2 dev $VXLAN_DEV
sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_2 via $OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_2 dev $VXLAN_DEV
