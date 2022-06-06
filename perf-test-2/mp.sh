#!/bin/bash

. ./config.sh

if [ $SUCCESS == "FALSE" ]; then
    echo "ERROR: Unsupported host: $(hostname)"
    exit
fi

if [[ $(hostname) == $SERVER1_NAME || $(hostname) == $SERVER2_NAME || $(hostname) == $SERVER3_NAME || $(hostname) == $SERVER4_NAME ]]; then
  # Setup multipath routes to get to other containers
  sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_1 \
    nexthop via $NEXT_HOP_1 dev $ETH_DEV  \
    nexthop via $NEXT_HOP_2 dev $ETH_DEV
  sudo ip route replace $OTHER_SERVER_CONTAINER_SUBNET_2 \
    nexthop via $NEXT_HOP_1 dev $ETH_DEV  \
    nexthop via $NEXT_HOP_2 dev $ETH_DEV

  # Enable L4 ECMP hashing
  sudo sysctl net.ipv4.fib_multipath_hash_policy=1

elif [[ $(hostname) == $GATEWAY1_NAME || $(hostname) == $GATEWAY2_NAME ]]; then
  echo "This is a gateway node. No action taken"
else
  echo "Error, invalid hostname: $(hostname)"
fi
