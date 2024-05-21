#!/bin/bash

function select_drive {
  echo "Available drives:"
  lsblk -lnpo NAME,SIZE,TYPE | grep part | nl
  echo -n "Select the number of the drive to choose: "
  read selection
  drive=$(lsblk -lnpo NAME,TYPE | grep part | sed -n "${selection}p" | awk '{print $1}')
  if [ -z "$drive" ]; then
    echo "Invalid selection."
    exit 1
  fi
  echo "You have selected: $drive"
}

for cmd in mkdosfs blockdev mlabel; do
  if ! command -v $cmd &> /dev/null; then
    echo "Error: The tool '$cmd' is not installed or not found in the PATH."
    exit 1
  fi
done

select_drive

if [ ! -b "$drive" ]; then
  echo "Error: The drive $drive does not exist."
  exit 1
fi

echo "Creating working directory..."
mkdir -p flash
cd flash

if [ $? -ne 0 ]; then
  echo "Error: Unable to create the working directory."
  exit 1
fi

echo "Creating 1TB temporary file..."
mkdosfs -C temp_file 1000000000
if [ $? -ne 0 ]; then
  echo "Error: Failed to create the temporary file."
  cd ..
  rm -rf flash
  exit 1
fi

echo "Unmounting the drive $drive..."
sudo umount "$drive" || echo "The drive $drive was not mounted, continuing..."
if [ $? -ne 0 ] && mount | grep "$drive" > /dev/null; then
  echo "Error: Unable to unmount the drive $drive."
  cd ..
  rm -rf flash
  exit 1
fi

echo "Writing temporary file for spoofing..."
drive_size=$(sudo blockdev --getsize64 "$drive")
spoofing_size=$(($drive_size / 1024 / 1024))
echo "Drive size: ${spoofing_size} MB"
dd if=temp_file of="$drive" bs=1M count=${spoofing_size}
if [ $? -ne 0 ]; then
  echo "Error: Failed to write the temporary file for spoofing."
  cd ..
  rm -rf flash
  exit 1
fi

echo "Setting the label for the drive..."
sudo env MTOOLS_SKIP_CHECK=1 mlabel -i "$drive" ::1TB_DRIVE
if [ $? -ne 0 ]; then
  echo "Error: Failed to set the label for the drive."
  cd ..
  rm -rf flash
  exit 1
fi

echo "Storage spoofing completed on $drive."

echo "Cleaning up temporary files..."
cd ..
rm -rf flash

echo "Cleanup completed. Procedure finished."

