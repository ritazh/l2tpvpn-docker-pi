#!/bin/sh
#
echo $(date +"%F %T%z") "starting script setupDocker.sh"

MYIP=`host raspberrypi | grep 'address' | cut -d' ' -f4`
cwd=$PWD

if [ -z "$MYGATEWAY" ]; then
  echo "Error: Missing environment variable MYGATEWAY".
  exit 0
fi
if [ -z "$MYUSERNAME" ]; then
  echo "Error: Missing environment variable MYUSERNAME".
  exit 0
fi
if [ -z "$MYSECRET" ]; then
  echo "Error: Missing environment variable MYSECRET".
  exit 0
fi
if [ -z "$MYPASSWORD" ]; then
  echo "Error: Missing environment variable MYPASSWORD".
  exit 0
fi
if [ -z "$MYIP" ]; then
  echo "Error: Missing environment variable MYIP".
  exit 0
fi

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
  sudo su -c setupl2tpvpn.sh pi
fi

exit 1