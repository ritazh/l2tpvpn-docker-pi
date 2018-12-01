#!/bin/sh
#
echo $MYIP
echo $MYPASSWORD
echo $MYUSERNAME
echo $MYGATEWAY
echo $MYSECRET

sudo iptables --table nat --append POSTROUTING --jump MASQUERADE
echo "net.ipv4.ip_forward = 1" | tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects = 0" | tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.send_redirects = 0" | tee -a /etc/sysctl.conf
for vpn in /proc/sys/net/ipv4/conf/*; do echo 0 > $vpn/accept_redirects; echo 0 > $vpn/send_redirects; done
sysctl -p

echo "creating ipsec.conf"
cat > /etc/ipsec.conf << EOF
version 2.0
config setup

        nat_traversal=yes
        protostack=netkey
        virtual_private=%v4:192.168.0.0/16,%v4:10.0.0.0/8,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:!10.25$
        oe=off

conn L2TP-PSK-NAT
    rightsubnet=vhost:%priv
    also=L2TP-PSK-noNAT

conn L2TP-PSK-noNAT
        authby=secret
        pfs=no
        auto=add
        keyingtries=3
        # we cannot rekey for %any, let client rekey
        rekey=no
        # Apple iOS doesn't send delete notify so we need dead peer detection
        # to detect vanishing clients
        dpddelay=30
        dpdtimeout=120
        dpdaction=clear
        # Set ikelifetime and keylife to same defaults windows has
        ikelifetime=8h
        keylife=1h
        # l2tp-over-ipsec is transport mode
        type=transport
        #
        left=$MYIP
        #
        # For updated Windows 2000/XP clients,
        # to support old clients as well, use leftprotoport=17/%any
        leftprotoport=17/1701
        #
        # The remote user.
        #
        right=%any
        # Using the magic port of "%any" means "any one single port". This is
        # a work around required for Apple OSX clients that use a randomly
        # high port.
        rightprotoport=17/%any
        #force all to be nat'ed. because of ios
        forceencaps=yes
# Normally, KLIPS drops all plaintext traffic from IP's it has a crypted
# connection with. With L2TP clients behind NAT, that's not really what
# you want. The connection below allows both l2tp/ipsec and plaintext
# connections from behind the same NAT router.
# The l2tpd use a leftprotoport, so they are more specific and will be used
# first. Then, packets for the host on different ports and protocols (eg ssh)
# will match this passthrough conn.
conn passthrough-for-non-l2tp
        type=passthrough
        left=$MYIP
        leftnexthop=$MYGATEWAY
        right=0.0.0.0
        rightsubnet=0.0.0.0/0
        auto=route
EOF

echo "ipsec.conf done"

echo "$MYIP %any: PSK \"$MYSECRET\"" >> /etc/ipsec.secrets
echo "ipsec.secret done"

echo "creating xl2tpd.conf"

cat > /etc/xl2tpd/xl2tpd.conf << EOF

[global]
ipsec saref = yes
listen-addr = $MYIP
[lns default]
ip range = $MYIPRANGE_START-$MYIPRANGE_END
local ip = $MYIP
assign ip = yes
require chap = yes
refuse pap = yes
require authentication = yes
name = linkVPN
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
EOF

echo "xl2tpd.conf done"

echo "creating /etc/ppp/options.xl2tpd"
cat > /etc/ppp/options.xl2tpd << EOF

ipcp-accept-local
ipcp-accept-remote
ms-dns $MYGATEWAY
asyncmap 0
auth
crtscts
lock
idle 1800
mtu 1200
mru 1200
modem
debug
name l2tpd
proxyarp
lcp-echo-interval 30
lcp-echo-failure 4
nodefaultroute
connect-delay 5000

EOF

echo "/etc/ppp/options.xl2tpd done"

echo "edit /etc/ppp/chap-secrets"
echo "$MYUSERNAME * $MYPASSWORD *" >> /etc/ppp/chap-secrets
echo "/etc/ppp/chap-secrets done"

echo "add iptable rules"
sudo iptables -I INPUT -p UDP --dport 4500 -j ACCEPT
sudo iptables -I INPUT -p UDP --dport 500 -j ACCEPT

echo "install older openswan"
wget http://snapshot.raspbian.org/201403301125/raspbian/pool/main/o/openswan/openswan_2.6.37-3_armhf.deb
sudo dpkg -i openswan_2.6.37-3_armhf.deb

echo "restarting services"
modprobe af_key

/etc/init.d/xl2tpd restart
/etc/init.d/ipsec restart
tail -f /dev/null
