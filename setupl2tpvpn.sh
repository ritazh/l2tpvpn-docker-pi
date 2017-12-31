#!/bin/sh
#
echo $(date +"%F %T%z") "starting script setupl2tpvpn.sh"
echo $MYGATEWAY
echo $MYUSERNAME
echo $MYSECRET
echo $MYPASSWORD

MYIP=`host rasperrypi | grep 'address' | cut -d' ' -f4)`

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

curl -sSL https://get.docker.com | sh
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker pi
sudo su - pi

echo "----------------------------------"
echo " GET AND RUN ritazh/l2tpvpn DOCKER IMAGE"
echo "----------------------------------"

docker run -p 500:500/udp -p 4500:4500/udp -e MYIP=$MYIP -e MYGATEWAY=$MYGATEWAY -e MYUSERNAME=$MYUSERNAME -e MYPASSWORD=$MYPASSWORD -e MYSECRET=$MYSECRET --privileged --net=host -v /lib/modules:/lib/modules:ro -d ritazh/l2tpvpn
docker ps

echo "----------------------------------"
echo " A DOCKER CONTAINER SHOULD BE RUNNING"
echo " CONNECT TO YOUR VPN SERVER WITH: "
echo " USERNAME: $MYUSERNAME"
echo " SECRET: $MYSECRET"
echo " PASSWORD: $MYPASSWORD"
echo "----------------------------------"
