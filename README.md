# l2tpvpn-docker-pi

This solution provides a quick way to setup your own L2TP/IPsec VPN Server with Raspberry Pi and Docker. For reference of how this works, you can checkout my [blog post](https://ritazh.com/running-your-own-l2tp-ipsec-vpn-server-with-raspberry-pi-and-docker-7342e19498bd).

## Prerequisites

Follow this [blog post](https://ritazh.com/setup-your-own-l2tp-vpn-server-with-raspberry-pi-170d3d4df04c), complete step 1 through 6 to setup operating system on the Raspberry Pi and forward UDP port 500 and UDP port 4500 to your Raspberry Pi device.

## Usage

```bash
$ curl -LOk https://github.com/ritazh/l2tpvpn-docker-pi/archive/master.zip && unzip master.zip && cd l2tpvpn-docker-pi-master
$ export MYGATEWAY=<REDACTED>
$ export MYUSERNAME=<REDACTED>
$ export MYPASSWORD=<REDACTED>
$ export MYSECRET=<REDACTED>
$ export MYIPRANGE_START=<REDACTED>
$ export MYIPRANGE_END=<REDACTED>
$ sudo chmod 755 setupDocker.sh && sudo chmod 755 setupl2tpvpn.sh
$ ./setupDocker.sh
$ cd l2tpvpn-docker-pi-master
$ ./setupl2tpvpn.sh
```

## Output

```bash
----------------------------------
 SET STATIC IP
----------------------------------
----------------------------------
 GET AND RUN ritazh/l2tpvpn DOCKER IMAGE
----------------------------------
f4fcfd2482fa1e43545689f4ef1774bbbd10d1d37819cedd5248b90e6344bc74
----------------------------------
 DOCKER PS
 A DOCKER CONTAINER SHOULD BE RUNNING
----------------------------------
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                  PORTS               NAMES
f4fcfd2482fa        ritazh/l2tpvpn      "/usr/bin/entry.sh /…"   1 second ago        Up Less than a second                       optimistic_dijkstra
----------------------------------
 MAKE SURE TO FORWARD UDP PORT 500 AND UDP PORT 4500 TO <REDACTED>

 CONNECT TO YOUR VPN SERVER WITH:
 USERNAME: <REDACTED>
 SECRET: <REDACTED>
 PASSWORD: <REDACTED>
----------------------------------
```

## Contributing

This solution welcomes contributions and suggestions. Feel free to file issues and create pull requests.
