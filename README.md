# mp-test-scripts

## Overview

This repo contains a set of scripts used to configure 4, 6 and 8-node Linux
networks for the purpose of performance testing of various configurations
including:

- Native Linux routing
- Routing over VXLAN tunnels
- Routing over GRE tunnels
- ECMP routing using multiple equally weighted next hops
- 0, 1 and two hops

These test scripts were used on several virtualized (VM) test beds including AWS
and two different private Linux servers.  They should work on bare metal machines
as well.

## Description of Directories

Each directory contains:

1. "updatevms" scripts copy code from current directory to all VMs
   1. `updatevms.sh`: used on private servers
   2. `awsupdatevms.sh`: used on AWS testbed
2. `config.sh`: Testbed configuration (may need to be modified for your setup)
3. `setup.sh`: Initial setup (must be executed first)
4. `test.sh`: Basic ping test. Should work after each step as been executed on all machines
   being used.

The intended order of script execution and a brief description is given for each setup below.
It is possible to execute the scripts in different orders, or go back and forth between the
different configurations, but not all combinations have been tested -- they were mainly
executed in the order shown below.

There are no "unconfigure" scripts, so the VMs must be rebooted between test setups to go back
to the initial state.

### perf-test-1: 4-node setup

1. `./setup.sh`: Initial setup with standard Linux routing
2. `./vxlan-all.sh`: Add VXLAN tunnels for communication between network namespaces

There is also a `gre.sh` that sets up GRE tunnels between s1 <-> s3, and s2 <-> s4

### perf-test-2: 6-node setup

1. `./setup.sh`: Initial setup with standard Linux routing
2. `./mp.sh`: Add multipath routing
3. `./vxlan.sh`: Non-multipath routing over VXLAN tunnels
4. `./vxlan-mp.sh`: Multipath routing over VXLAN tunnels

### perf-test-3: 8-node setup

1. `./setup.sh`: Initial setup with routing over VXLAN tunnels

    NOTE: Non VXLAN was not tested on the 8-node setup

2. `./mp.sh`: Add multipath routing over VXLAN tunnels


