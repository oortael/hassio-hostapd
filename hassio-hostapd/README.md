# hassio-hostapd
Raspberry Pi as hotspot in hass.io

Buy the original author a coffee:
[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

### This Hass.io Addon

This add-on allows you  to use the Raspberry Pi as a hotspot to connect the different devices directly to the `hass.io` network without going through the router.

## Installation

To use this repository with your own Hass.io installation please follow [the official instructions](https://www.home-assistant.io/hassio/installing_third_party_addons/) on the Home Assistant website with the following URL:

```txt
https://github.com/oortael/hassio-hostapd
```

### Configuration

The available configuration options are as follows (this is filled in with some example data):

```
{
    "ssid": "WIFI_NAME",
    "wpa_passphrase": "WIFI_PASSWORD",
    "channel": "6",
    "address": "192.168.99.1",
    "netmask": "255.255.255.0",
    "broadcast": "192.168.99.255",
    "interface": "wlan0",
    "hide_ssid": "0",
    "allow_mac_addresses": [],
    "deny_mac_addresses": ['ab:cd:ef:fe:dc:ba'],
    "country": "CA"
}
```
**Required config options**: ssid, wpa_passphrase, channel, address, netmask, broadcast

**Optional config options**: interface (defaults to wlan0), hide_ssid (defaults to 0/visible), allow_mac_addresses, deny_mac_addresses, country (defaults to unspecified)

**Note**: _This is just an example, don't copy and paste it! Create your own!_

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg
[buymeacoffee]: https://www.buymeacoffee.com/davidramosweb
