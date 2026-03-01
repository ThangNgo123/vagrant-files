#!/usr/bin/env bash
#
# Set up /etc/hosts so we can resolve all the nodes

set -e

NUM_WORKER_NODES=$1

# Determine machine IP from route table
MY_IP=""
for i in $(seq 1 10); do
    echo "Trying to detect node IP..."
    sleep 1
    MY_IP="$(ip -4 -o addr show eth1 | awk '{print $4}' | cut -d/ -f1)"
    if [ "$MY_IP" != "" ]; then
        break
    fi
done

if [ "$MY_IP" == "" ]; then
    echo "Failed to determine IP"
    exit 1
fi

# Determine network prefix
MY_NETWORK=$(echo $MY_IP | awk -F '.' '{print $1"."$2"."$3}')

# Script used by Vagrant trigger to get node IP
cat <<EOF > /usr/local/bin/public-ip
#!/usr/bin/env sh
echo -n $MY_IP
EOF

chmod +x /usr/local/bin/public-ip

# Clean unwanted entries
sed -i '/ubuntu-jammy/d' /etc/hosts
sed -i "/${HOSTNAME}/d" /etc/hosts

# Export primary IP
echo "PRIMARY_IP=${MY_IP}" >> /etc/environment
