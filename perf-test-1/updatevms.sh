#!/bin/bash
. ./config.sh

USERNAME="username"

for node_ip in "${NODE_IPS[@]}"
do
  echo "*** Updating node $node_ip ***"
  scp -o ConnectTimeout=2 ./* $USERNAME@$node_ip:/home/$USERNAME/
done
