#!/bin/bash

. ./config.sh

echo "ping other nodes from node"
for node_ip in "${NODE_IPS[@]}"
do
 ping -c 1 $node_ip
done

echo "ping containers from node"
for container_ip in "${CONTAINER_IPS[@]}"
do
	ping -c 1 $container_ip
done

echo "ping containers from containers"
for container in "${CONTAINERS[@]}"
do
	for container_ip in "${CONTAINER_IPS[@]}"
	do
		sudo ip netns exec $container ping -c 1 $container_ip
	done
done
