#!/bin/bash

. ./config.sh

if [ $SUCCESS == "FALSE" ]; then
    echo "ERROR: Unsupported host: $(hostname)"
    exit
fi

if [[ $(hostname) == $SERVER1_NAME || $(hostname) == $SERVER2_NAME || $(hostname) == $SERVER3_NAME || $(hostname) == $SERVER4_NAME ]]; then
  sudo bridge fdb append to 00:00:00:00:00:00 dst $NEXT_HOP_2 dev $VXLAN_LOCAL_DEV

  # Setup multipath routes to remote containers
  sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_1 \
    nexthop via $NEXT_HOP_1_VXLAN_IP dev $VXLAN_LOCAL_DEV  \
    nexthop via $NEXT_HOP_2_VXLAN_IP dev $VXLAN_LOCAL_DEV
  sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_2 \
    nexthop via $NEXT_HOP_1_VXLAN_IP dev $VXLAN_LOCAL_DEV  \
    nexthop via $NEXT_HOP_2_VXLAN_IP dev $VXLAN_LOCAL_DEV

elif [[ $(hostname) == $GATEWAY1_NAME || $(hostname) == $GATEWAY2_NAME ]]; then

  # Add Remote VXLAN Tunnels
  sudo bridge fdb append to 00:00:00:00:00:00 dst $GATEWAY4_IP dev $VXLAN_REMOTE_DEV

  # Add remote routes
  sudo ip route replace $SERVER3_CONTAINER_SUBNET \
    nexthop via $GATEWAY3_VXLAN_REMOTE_IP dev $VXLAN_REMOTE_DEV \
    nexthop via $GATEWAY4_VXLAN_REMOTE_IP dev $VXLAN_REMOTE_DEV
  sudo ip route replace $SERVER4_CONTAINER_SUBNET \
    nexthop via $GATEWAY3_VXLAN_REMOTE_IP dev $VXLAN_REMOTE_DEV \
    nexthop via $GATEWAY4_VXLAN_REMOTE_IP dev $VXLAN_REMOTE_DEV

elif [[ $(hostname) == $GATEWAY3_NAME || $(hostname) == $GATEWAY4_NAME ]]; then

  # Add Remote VXLAN Tunnels
  sudo bridge fdb append to 00:00:00:00:00:00 dst $GATEWAY2_IP dev $VXLAN_REMOTE_DEV

  # Add remote routes
  sudo ip route replace $SERVER1_CONTAINER_SUBNET \
    nexthop via $GATEWAY1_VXLAN_REMOTE_IP dev $VXLAN_REMOTE_DEV \
    nexthop via $GATEWAY2_VXLAN_REMOTE_IP dev $VXLAN_REMOTE_DEV
  sudo ip route replace $SERVER2_CONTAINER_SUBNET \
    nexthop via $GATEWAY1_VXLAN_REMOTE_IP dev $VXLAN_REMOTE_DEV \
    nexthop via $GATEWAY2_VXLAN_REMOTE_IP dev $VXLAN_REMOTE_DEV

else
  echo "Error, invalid hostname: $(hostname)"
  exit
fi
