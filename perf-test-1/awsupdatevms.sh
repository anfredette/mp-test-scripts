#!/bin/bash

NODE_IPS=("3.83.124.49" "35.175.244.158" "100.26.106.34" "44.202.100.102")

for node_ip in "${NODE_IPS[@]}"
do
  echo "*** Updating node $node_ip ***"
  scp -i ~/.ssh/aws.pim -o ConnectTimeout=5 ./* fedora@$node_ip:/home/fedora
done
