FROM alpine:latest

RUN apk add --no-cache openvpn curl unzip

COPY openvpn.sh /usr/local/bin/openvpn.sh

RUN chmod +x /usr/local/bin/openvpn.sh

ENV REGION="US West"
ENTRYPOINT ["openvpn.sh"]
