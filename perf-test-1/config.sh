#!/bin/bash

CON1="con1"
# ETH_DEV="eth0"
# ETH_DEV="enp0s8"
ETH_DEV="ens3"
VXLAN_DEV="vxlan0"
VXLAN_PORT="4500"
VXLAN_VNI="1000"

# Server names:
SERVER1_NAME="s1"
SERVER2_NAME="s2"
SERVER3_NAME="s3"
SERVER4_NAME="s4"

# AWS Server IPs:
# SERVER1_IP="10.10.0.92"
# SERVER2_IP="10.10.0.150"
# SERVER3_IP="10.10.0.169"
# SERVER4_IP="10.10.0.215"

# VBox Server IPs:
SERVER1_IP="10.1.0.11"
SERVER2_IP="10.1.0.12"
SERVER3_IP="10.1.0.13"
SERVER4_IP="10.1.0.14"

SERVER1_VXLAN_IP="10.50.0.1"
SERVER2_VXLAN_IP="10.50.0.2"
SERVER3_VXLAN_IP="10.50.0.3"
SERVER4_VXLAN_IP="10.50.0.4"

SERVER1_TUNNEL_IP="10.200.1.1"
SERVER2_TUNNEL_IP="10.200.1.2"
SERVER3_TUNNEL_IP="10.200.1.3"
SERVER4_TUNNEL_IP="10.200.1.4"

CONTAINERS=($CON1)
CONTAINER_IPS=("10.100.1.2" "10.100.2.2" "10.100.3.2" "10.100.4.2")
NODE_IPS=($SERVER1_IP $SERVER2_IP $SERVER3_IP $SERVER4_IP)

SUCCESS="TRUE"

if [ $(hostname) == $SERVER1_NAME ]; then
    NODE_IP=$SERVER1_IP
    BRIDGE_IP="10.100.1.1"
    CON1_IP="10.100.1.2"
    VXLAN_IP="$SERVER1_VXLAN_IP"

    LOCAL_TUNNEL_ENDPOINT=$SERVER1_IP
    REMOTE_TUNNEL_ENDPOINT=$SERVER3_IP
    LOCAL_TUNNEL_IP=$SERVER1_TUNNEL_IP
    REMOTE_TUNNEL_IP=$SERVER3_TUNNEL_IP

    OTHER_SERVER_CONTAINER_SUBNET_1="10.100.3.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_1=$SERVER3_IP
    OTHER_SERVER_VXLAN_NODE_1=$SERVER3_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_1="$SERVER3_VXLAN_IP"

    OTHER_SERVER_CONTAINER_SUBNET_2="10.100.4.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_2=$SERVER4_IP
    OTHER_SERVER_VXLAN_NODE_2=$SERVER4_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_2="$SERVER4_VXLAN_IP"

    OTHER_SERVER_CONTAINER_SUBNET_3="10.100.2.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_3=$SERVER2_IP
    OTHER_SERVER_VXLAN_NODE_3=$SERVER2_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_3="$SERVER2_VXLAN_IP"

elif [ $(hostname) == $SERVER2_NAME ]; then
    NODE_IP=$SERVER2_IP
    BRIDGE_IP="10.100.2.1"
    CON1_IP="10.100.2.2"
    VXLAN_IP="$SERVER2_VXLAN_IP"

    LOCAL_TUNNEL_ENDPOINT=$SERVER2_IP
    REMOTE_TUNNEL_ENDPOINT=$SERVER4_IP
    LOCAL_TUNNEL_IP=$SERVER2_TUNNEL_IP
    REMOTE_TUNNEL_IP=$SERVER4_TUNNEL_IP

    OTHER_SERVER_CONTAINER_SUBNET_1="10.100.4.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_1=$SERVER4_IP
    OTHER_SERVER_VXLAN_NODE_1=$SERVER4_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_1="$SERVER4_VXLAN_IP"

    OTHER_SERVER_CONTAINER_SUBNET_2="10.100.3.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_2=$SERVER3_IP
    OTHER_SERVER_VXLAN_NODE_2=$SERVER3_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_2="$SERVER3_VXLAN_IP"

    OTHER_SERVER_CONTAINER_SUBNET_3="10.100.1.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_3=$SERVER1_IP
    OTHER_SERVER_VXLAN_NODE_3=$SERVER1_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_3="$SERVER1_VXLAN_IP"

elif [ $(hostname) == $SERVER3_NAME ]; then
    NODE_IP=$SERVER3_IP
    BRIDGE_IP="10.100.3.1"
    CON1_IP="10.100.3.2"
    VXLAN_IP="$SERVER3_VXLAN_IP"

    LOCAL_TUNNEL_ENDPOINT=$SERVER3_IP
    REMOTE_TUNNEL_ENDPOINT=$SERVER1_IP
    LOCAL_TUNNEL_IP=$SERVER3_TUNNEL_IP
    REMOTE_TUNNEL_IP=$SERVER1_TUNNEL_IP

    OTHER_SERVER_CONTAINER_SUBNET_1="10.100.1.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_1=$SERVER1_IP
    OTHER_SERVER_VXLAN_NODE_1=$SERVER1_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_1="$SERVER1_VXLAN_IP"

    OTHER_SERVER_CONTAINER_SUBNET_2="10.100.2.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_2=$SERVER2_IP
    OTHER_SERVER_VXLAN_NODE_2=$SERVER2_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_2="$SERVER2_VXLAN_IP"

    OTHER_SERVER_CONTAINER_SUBNET_3="10.100.4.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_3=$SERVER4_IP
    OTHER_SERVER_VXLAN_NODE_3=$SERVER4_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_3="$SERVER4_VXLAN_IP"

elif [ $(hostname) == $SERVER4_NAME ]; then
    NODE_IP=$SERVER1_IP
    BRIDGE_IP="10.100.4.1"
    CON1_IP="10.100.4.2"
    VXLAN_IP="$SERVER4_VXLAN_IP"

    LOCAL_TUNNEL_ENDPOINT=$SERVER4_IP
    REMOTE_TUNNEL_ENDPOINT=$SERVER2_IP
    LOCAL_TUNNEL_IP=$SERVER4_TUNNEL_IP
    REMOTE_TUNNEL_IP=$SERVER2_TUNNEL_IP

    OTHER_SERVER_CONTAINER_SUBNET_1="10.100.2.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_1=$SERVER2_IP
    OTHER_SERVER_VXLAN_NODE_1=$SERVER2_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_1="$SERVER2_VXLAN_IP"

    OTHER_SERVER_CONTAINER_SUBNET_2="10.100.1.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_2=$SERVER1_IP
    OTHER_SERVER_VXLAN_NODE_2=$SERVER1_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_2="$SERVER1_VXLAN_IP"

    OTHER_SERVER_CONTAINER_SUBNET_3="10.100.3.0/24"
    OTHER_SERVER_CONTAINER_NEXT_HOP_3=$SERVER3_IP
    OTHER_SERVER_VXLAN_NODE_3=$SERVER3_IP
    OTHER_SERVER_CONTAINER_VXLAN_NEXT_HOP_3="$SERVER3_VXLAN_IP"

else
    SUCCESS="FALSE"
fi