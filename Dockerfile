FROM alpine:3.9.2

RUN apk update
RUN apk add bridge hostapd wireless-tools wpa_supplicant dnsmasq iw iptables sed bash macchanger

COPY hostapd.conf /etc/hostapd.conf

# define build args
ARG wlan_int
ARG channel
ARG hotspot_int

# define env vars
ENV WLAN_INT $wlan_int
ENV CHANNEL $channel
ENV HOTSPOT_INT $hotspot_int

RUN sed -i -s "s/^interface=.*/interface=${hotspot_int}/" /etc/hostapd.conf
RUN sed -i -s "s/^channel=.*/channel=${channel}/" /etc/hostapd.conf

ADD bootstrap.sh /bin/bootstrap.sh

ENTRYPOINT [ "/bin/bootstrap.sh" ]
