#!/bin/bash

# Clear the terminal screen
clear

# Change directory to the script location and then to ./QEMU
#cd "$(dirname "$0")/QEMU" || exit

# Set memory size
MEM=4000

# Get the device number for the USB drive (assuming it's the mount point of the script)
DEV_PATH=$(df "$0" | tail -1 | awk '{print $1}')
if [ -z "$DEV_PATH" ]; then
  echo "Could not determine device path."
  exit 1
fi

# Extract the device path
DN=$(df --output=source "$(dirname "$(realpath "$0")")" | tail -n 1 | sed 's/[0-9]*$//')

# Show drive number and memory size
echo "QEMU VM STARTING FROM = $DN ($DEV_PATH)"
echo "FIRMWARE TYPE = BIOS"
echo "AMOUNT OF RAM = $MEM"

# Flush file system buffers
sync

# Set the qemu executable
QEMU=qemu-system-x86_64  # Assuming using QEMU for 64-bit, adjust if needed

# Set the QEMU command
CMD="sudo $QEMU -L . -name 'BIOS Boot - $DN' -vga std -boot c -m $MEM -drive file=$DN,if=ide,index=0,media=disk,format=raw"

# Execute the QEMU command
# echo $CMD
eval "$CMD" 2>/dev/null

# Check if QEMU failed to run
if [ $? -ne 0 ]; then
  echo "FAILED!"
  read -p "Press any key to continue..."
fi

# Rescan drives (similar to Windows DISKPART's RESCAN, but on Linux it's unnecessary unless specific scenarios apply)
# lsblk or udevadm trigger --action=add may be used if needed.

exit 0

