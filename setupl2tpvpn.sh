#!/bin/sh
#
echo $(date +"%F %T%z") "starting script setupl2tpvpn.sh"
echo $MYGATEWAY
echo $MYIP
echo $cwd

cd $cwd

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

docker run -p 500:500/udp -p 4500:4500/udp -e MYIP=$MYIP -e MYGATEWAY=$MYGATEWAY -e MYUSERNAME=$MYUSERNAME -e MYPASSWORD=$MYPASSWORD -e MYSECRET=$MYSECRET --privileged --net=host -v /lib/modules:/lib/modules:ro -d ritazh/l2tpvpn
docker ps

echo "----------------------------------"
echo " docker ps"
echo " A DOCKER CONTAINER SHOULD BE RUNNING"
echo " CONNECT TO YOUR VPN SERVER WITH: "
echo " USERNAME: $MYUSERNAME"
echo " SECRET: $MYSECRET"
echo " PASSWORD: $MYPASSWORD"
echo "----------------------------------"

exit 1
