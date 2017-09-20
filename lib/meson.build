libpn_sources = [
  'DeviceManager.vala',
  'Device.vala',
  'DeviceWifi.vala',
  'WirelessConnection.vala',
  'StaticWEPConnection.vala',
  'LEAPConnection.vala',
  'WPAPersonalConnection.vala',
  '8021xConnection.vala',
  'HotspotConnection.vala',
  'Enums.vala',
  'Widgets/HotspotDialog.vala',
  'Widgets/WifiHiddenDialog.vala'
]

c_args = [
  '-include', 'config.h'
]

libpn = shared_library(
  meson.project_name(),
  sources: libpn_sources,
  c_args: c_args,
  dependencies: deps,
  install: true,
  install_dir : [true, true, true]
)
