#!/bin/sh
set -e -u -o pipefail

# These are the possible bundles from PIA
# https://www.privateinternetaccess.com/openvpn/openvpn.zip
# https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip
# https://www.privateinternetaccess.com/openvpn/openvpn-tcp.zip
# https://www.privateinternetaccess.com/openvpn/openvpn-strong-tcp.zip

baseURL="https://www.privateinternetaccess.com/openvpn"
PIA_OPENVPN_CONFIG_BUNDLE=${PIA_OPENVPN_CONFIG_BUNDLE:-"openvpn"}
VPN_PROVIDER_HOME=/pia

# Download and extract wanted bundle into temporary file
tmp_file=$(mktemp)
echo "Downloading OpenVPN config bundle $PIA_OPENVPN_CONFIG_BUNDLE into temporary file $tmp_file"
curl -sSL --cookie /dev/null "${baseURL}/${PIA_OPENVPN_CONFIG_BUNDLE}.zip" -o "$tmp_file"

echo "Extract OpenVPN config bundle into PIA directory $VPN_PROVIDER_HOME"
mkdir -p $VPN_PROVIDER_HOME
unzip -qjo "$tmp_file" -d "$VPN_PROVIDER_HOME"

set -- "$@" '--config' "${REGION:-us_west}.ovpn"

if [ ! -f auth.conf ]; then
  echo "${USERNAME:-NONE PROVIDED}" > auth.conf
  echo "${PASSWORD:-NONE PROVIDED}" >> auth.conf
  chmod 600 auth.conf
fi

set -- "$@" '--auth-user-pass' 'auth.conf'

openvpn "$@"
