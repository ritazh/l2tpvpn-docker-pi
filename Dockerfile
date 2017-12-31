FROM resin/rpi-raspbian:latest
LABEL maintainer="Rita Zhang <rita.z.zhang@gmail.com>"

WORKDIR /opt/src

ENV MYIP $MYIP
ENV MYGATEWAY $MYGATEWAY
ENV MYUSERNAME $MYUSERNAME
ENV MYSECRET $MYSECRET
ENV MYPASSWORD $MYPASSWORD

RUN sudo apt-get -yqq update \
    && DEBIAN_FRONTEND=noninteractive sudo apt-get install --yes --force-yes iptables openswan \
    && sudo apt-get -yqq install wget xl2tpd ppp lsof vim

COPY ./run.sh /opt/src/run.sh
RUN chmod 755 /opt/src/run.sh

EXPOSE 500/udp 4500/udp

VOLUME ["/lib/modules"]

CMD ["/opt/src/run.sh"]
