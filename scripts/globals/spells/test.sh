#!/bin/bash

# Ports to check (RDP and Plex)
PORTS=(3389 32400)

# Function to perform bitwise AND on IP and mask octets
and_octets() {
    local ip=$1 mask=$2
    IFS=. read i1 i2 i3 i4 <<< "$ip"
    IFS=. read m1 m2 m3 m4 <<< "$mask"
    echo "$((i1 & m1)).$((i2 & m2)).$((i3 & m3)).$((i4 & m4))"
}

# Function to get CIDR from netmask
cidr_from_netmask() {
    local mask=$1
    local cidr=0
    IFS=. read m1 m2 m3 m4 <<< "$mask"
    for m in $m1 $m2 $m3 $m4; do
        while [ $m -ne 0 ]; do
            cidr=$((cidr + (m & 1)))
            m=$((m >> 1))
        done
    done
    echo $cidr
}

# Get default interface
INTERFACE=$(route get default 2>/dev/null | grep interface | cut -d: -f2 | sed 's/ //g')
if [ -z "$INTERFACE" ]; then
    echo "Error: No default interface found."
    exit 1
fi

# Get IP, netmask (hex), broadcast
IP_LINE=$(ifconfig "$INTERFACE" 2>/dev/null | grep 'inet ')
if [ -z "$IP_LINE" ]; then
    echo "Error: No IP address found for interface $INTERFACE."
    exit 1
fi

LOCAL_IP=$(echo "$IP_LINE" | awk '{print $2}')
NETMASK_HEX=$(echo "$IP_LINE" | awk '{print $4}')
BROADCAST=$(echo "$IP_LINE" | awk '{print $6}')

# Convert netmask hex to decimal dotted quad
NETMASK_DEC=$(printf "%d.%d.%d.%d" 0x${NETMASK_HEX:2:2} 0x${NETMASK_HEX:4:2} 0x${NETMASK_HEX:6:2} 0x${NETMASK_HEX:8:2})

# Calculate network address
NETWORK=$(and_octets "$LOCAL_IP" "$NETMASK_DEC")

# Get CIDR
CIDR=$(cidr_from_netmask "$NETMASK_DEC")

# Function to scan specified ports on a host
port_scan() {
    local host=$1
    echo "  Scanning for RDP/Plex on $host..."
    for port in "${PORTS[@]}"; do
        # Attempt a TCP connection; -z for scan mode, -w1 to wait 1s
        nc -z -w1 "$host" "$port" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            case "$port" in
                3389) label="RDP (3389)";;
                32400) label="Plex (32400)";;
                *) label="port $port";;
            esac
            echo "    $label is open on $host"
        fi
    done
}

# Function to perform ping sweep + targeted port scan
ping_sweep() {
    echo "Scanning network: $NETWORK/$CIDR"
    echo "Looking only for RDP (3389) and Plex (32400) on live hosts..."
    IFS='.' read -r i1 i2 i3 i4 <<< "$NETWORK"

    # If broadcast available, try to parse; otherwise fall back to /24 scan window
    if [ -n "$BROADCAST" ]; then
        IFS='.' read -r b1 b2 b3 b4 <<< "$BROADCAST"
    else
        # fallback: assume /24
        b1=$i1; b2=$i2; b3=$i3; b4=255
    fi

    for i in $(seq $i1 $b1); do
        if [ $i -eq $i1 ]; then startj=$i2; else startj=0; fi
        if [ $i -eq $b1 ]; then endj=$b2; else endj=255; fi
        for j in $(seq $startj $endj); do
            if [ $i -eq $i1 ] && [ $j -eq $i2 ]; then startk=$i3; else startk=0; fi
            if [ $i -eq $b1 ] && [ $j -eq $b2 ]; then endk=$b3; else endk=255; fi
            for k in $(seq $startk $endk); do
                if [ $i -eq $i1 ] && [ $j -eq $i2 ] && [ $k -eq $i3 ]; then startl=$(($i4 + 1)); else startl=0; fi
                if [ $i -eq $b1 ] && [ $j -eq $b2 ] && [ $k -eq $b3 ]; then endl=$(($b4 - 1)); else endl=255; fi
                for l in $(seq $startl $endl); do
                    IP="$i.$j.$k.$l"
                    if [ "$IP" != "$LOCAL_IP" ]; then
                        # quick reachability test
                        ping -c 1 -t 1 "$IP" >/dev/null 2>&1
                        if [ $? -eq 0 ]; then
                            echo "$IP is up"
                            port_scan "$IP"
                        fi
                    fi
                done
            done
        done
    done
}

ping_sweep

