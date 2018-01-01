#!/bin/sh
#
echo $(date +"%F %T%z") "starting script setupl2tpvpn.sh"
cd l2tpvpn-docker-pi-master

MYIP=`hostname -I | cut -d' ' -f1`

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
echo " SET STATIC IP"
echo "----------------------------------"

echo -e "interface eth0
static ip_address=$MYIP/24
static routers=$MYGATEWAY
static domain_name_servers=$MYGATEWAY" >> /etc/dhcpcd.conf

echo "----------------------------------"
echo " GET AND RUN ritazh/l2tpvpn DOCKER IMAGE"
echo "----------------------------------"
modprobe af_key
docker run -p 500:500/udp -p 4500:4500/udp -e MYIP=$MYIP -e MYGATEWAY=$MYGATEWAY -e MYUSERNAME=$MYUSERNAME -e MYPASSWORD=$MYPASSWORD -e MYSECRET=$MYSECRET --privileged --net=host -v /lib/modules:/lib/modules:ro -d ritazh/l2tpvpn

echo "----------------------------------"
echo " DOCKER PS"
echo " A DOCKER CONTAINER SHOULD BE RUNNING"
echo "----------------------------------"
docker ps

echo "----------------------------------"
echo " MAKE SURE TO FORWARD UDP PORT 500 AND UDP PORT 4500 TO $MYIP"
echo "                                  "
echo " CONNECT TO YOUR VPN SERVER WITH: "
echo " USERNAME: $MYUSERNAME"
echo " SECRET: $MYSECRET"
echo " PASSWORD: $MYPASSWORD"
echo "----------------------------------"
