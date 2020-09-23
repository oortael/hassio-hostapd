# Changelog

## [1.0.4]
### Fixed
- Remove networkmanager, net-tools, sudo versions (as per https://github.com/davidramosweb/hassio-addons/pull/15, https://github.com/davidramosweb/hassio-addons/pull/8, https://github.com/davidramosweb/hassio-addons/issues/14, https://github.com/davidramosweb/hassio-addons/issues/13)
- Corrected broadcast address (as per https://github.com/davidramosweb/hassio-addons/pull/1)


### Changed
- Allow hidden SSIDs (as per https://github.com/davidramosweb/hassio-addons/pull/6)
- Allow specification of interface name (defaults to wlan0) (as per https://github.com/davidramosweb/hassio-addons/issues/11)
- Added MAC address filtering
- Enabled wmm ("QoS support, also required for full speed on 802.11n/ac/ax") - have tested on mutiple RPIs, but needs further compatibility testing, and potentially moving option to addon config
- Remove interfaces file. Now generate it with specified interface name

## [1.0.3]
### Fixed
- Update apk networkmanager and sudo in Dockefile. 

## [1.0.2]
### Fixed
- Disabled NetworkManager for wlan0 to prevent the addon stop working after a few minutes. 

## [1.0.1]
### Fixed
- Gracefully Stopping Docker Containers 

### Changed
- Apply Changelog Best Practices


## [1.0.0]
- Initial version