#!/bin/bash

# Build and deploy to BeagleBone Black
# Usage: ./deploy.sh

set -e

BBB_IP="192.168.6.2"
BBB_USER="root"
REMOTE_PATH="/root/pcd_driver"
LOCAL_BUILD_DIR="$(pwd)"

echo "========================================="
echo "Building kernel module..."
echo "========================================="

# Build the module
make clean
make all

if [ $? -eq 0 ]; then
	echo "Build successful!"
	
	echo "========================================="
	echo "Deploying to BeagleBone Black..."
	echo "========================================="
	
	# Create remote directory if it doesn't exist
	ssh ${BBB_USER}@${BBB_IP} "mkdir -p ${REMOTE_PATH}"
	
	# Copy the built module and Makefile
	scp pcd.ko ${BBB_USER}@${BBB_IP}:${REMOTE_PATH}/
	scp Makefile ${BBB_USER}@${BBB_IP}:${REMOTE_PATH}/
	
	echo "========================================="
	echo "Deployment complete!"
	echo "Module location: ${REMOTE_PATH}/pcd.ko"
	echo "========================================="
	echo ""
	echo "To load the module on BBB, run:"
	echo "ssh ${BBB_USER}@${BBB_IP} 'insmod ${REMOTE_PATH}/pcd.ko'"
else
	echo "Build failed!"
	exit 1
fi