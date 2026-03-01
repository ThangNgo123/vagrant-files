#!/usr/bin/env bash

# Stop script if any command fails
set -e

echo "Disabling swap..."

# Turn off swap immediately
sudo swapoff -a

# Comment out swap entries in /etc/fstab to disable swap permanently
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "Swap has been disabled."

# Verify
echo "Current swap status:"
swapon --show
