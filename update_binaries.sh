#!/bin/bash

get_os_arch() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)

    case "$os" in
        linux|darwin) ;;
        *) echo "Unsupported operating system: $os" >&2; return 1 ;;
    esac

    case "$arch" in
        x86_64|amd64) arch="amd64" ;;
        arm64|aarch64) arch="arm64" ;;
        *) echo "Unsupported architecture: $arch" >&2; return 1 ;;
    esac

    echo "${os}-${arch}"
}

# Base URL for the Quilibrium releases
BASE_URL="https://releases.quilibrium.com/release"

cd ~/ceremonyclient/node

# Get the current OS and architecture
OS_ARCH=$(get_os_arch)

# Fetch the list of files from the release page
FILES=$(curl -s $BASE_URL | grep -oE "node-[0-9]+\.[0-9]+\.[0-9]+-${OS_ARCH}(\.dgst)?(\.sig\.[0-9]+)?")


# Change to the download directory
cd ~/ceremonyclient/node

# Download each file
for file in $FILES; do
    echo "Downloading $file..."
    wget "https://releases.quilibrium.com/$file"
    
    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Successfully downloaded $file"
    else
        echo "Failed to download $file"
    fi
    
    echo "------------------------"
done

echo "Download process completed."
