#!/bin/bash

# Pull in the helper functions for configuring BigBlueButton
source /etc/bigbluebutton/bbb-conf/apply-lib.sh

enableUFWRules
ufw allow 6556

echo "  - Setting camera defaults"
yq w -i $HTML5_CONFIG public.kurento.cameraProfiles.[0].bitrate 50
yq w -i $HTML5_CONFIG public.kurento.cameraProfiles.[1].bitrate 100
yq w -i $HTML5_CONFIG public.kurento.cameraProfiles.[2].bitrate 200
yq w -i $HTML5_CONFIG public.kurento.cameraProfiles.[3].bitrate 300

yq w -i $HTML5_CONFIG public.kurento.cameraProfiles.[0].default true
yq w -i $HTML5_CONFIG public.kurento.cameraProfiles.[1].default false
yq w -i $HTML5_CONFIG public.kurento.cameraProfiles.[2].default false
yq w -i $HTML5_CONFIG public.kurento.cameraProfiles.[3].default false

echo "  - Disabling IPv6"
sed -i 's|<param name="listen-ip" value="::"/>|<param name="listen-ip" value="127.0.0.1"/>|g' /opt/freeswitch/etc/freeswitch/autoload_configs/event_socket.conf.xml
mv /opt/freeswitch/etc/freeswitch/sip_profiles/internal-ipv6.xml /opt/freeswitch/etc/freeswitch/sip_profiles/internal-ipv6.xml_
mv /opt/freeswitch/etc/freeswitch/sip_profiles/external-ipv6.xml /opt/freeswitch/etc/freeswitch/sip_profiles/external-ipv6.xml_

