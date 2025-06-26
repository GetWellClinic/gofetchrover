#!/bin/bash
# This script helps you install Docker, Docker Compose
# This script should be run as 'sudo ./install-docker.sh'
# Version 2025.06.06
# Add Docker's official GPG key:

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (e.g., with: sudo ./install-docker.sh)"
  exit 1
fi

set -e  # Exit immediately if a command exits with a non-zero status

echo "Updating package lists..."
apt-get update

echo "Installing required packages..."
apt-get install -y ca-certificates curl gnupg lsb-release

echo "Adding Docker's official GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package lists again..."
apt-get update

echo "Installing Docker components..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker

echo "Adding user '$USER' to docker group..."
usermod -aG docker $USER

echo "Docker installation complete."
echo "Please reboot to apply the changes."
