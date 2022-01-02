FROM alpine:latest

RUN apk add --no-cache openvpn curl unzip

COPY openvpn.sh /usr/local/bin/openvpn.sh

RUN chmod +x /usr/local/bin/openvpn.sh

RUN mkdir -p /pia
WORKDIR /pia

ENV REGION="us_west"
ENTRYPOINT ["openvpn.sh"]
