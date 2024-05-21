# Spoof my Drive - Spoofed Flash Drive Script

## Introduction

This script is designed to spoof the storage capacity of a USB flash drive, mimicking the behavior of scammers who sell spoofed flash drives on platforms like Amazon, Aliexpress, even local marketplaces. It allows users to select a connected drive and create a fake storage space on it (1 Terabyte), making it appear larger than its actual capacity. This script also changes the device label to 1TB_DRIVE, readable on the connected device.

I got the idea for this script after watching a [video on YouTube](https://youtu.be/DMz8i_ASGaE?si=A9th8cTUg98TR6Mz&t=705) about the scam of spoofed flash drives on Amazon. I wanted to emulate how those scammers perform this scam in order to raise awareness about it.

Please use this script only for educational purposes.

## Installation

### Prerequisites

- `bash`: The script is written in Bash and requires a Bash-compatible shell to run.
- `mkdosfs`: Used to create the temporary file system on the drive.
- `blockdev`: Used to get information about block devices, such as drive size.
- `mlabel`: Used to set the label for the drive.
- `lsblk`: Used to list block devices and their properties.

### Installation Steps

1. Clone the repository:

    ```bash
    git clone https://github.com/e1digitalpf/spoof-my-drive.git
    ```

2. Navigate to the directory:

    ```bash
    cd spoof-my-drive
    ```

3. Make the script executable:

    ```bash
    chmod +x main.sh
    ```

## Usage

1. Connect the USB flash drive to your computer.

2. Run the script:

    ```bash
    sudo ./main.sh
    ```

3. Follow the on-screen instructions to select the drive and complete the spoofing process.
