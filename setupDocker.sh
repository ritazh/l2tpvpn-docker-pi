#!/bin/sh
#
echo $(date +"%F %T%z") "starting script setupDocker.sh"

echo "----------------------------------"
echo " INSTALLING DOCKER"
echo "----------------------------------"

if [ -x "$(command -v docker)" ]; then
  echo " Docker is already installed"
else
  echo " Install docker"
  curl -sSL https://get.docker.com | sh
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker pi
  sudo su - pi
fi