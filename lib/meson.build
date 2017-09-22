libpn_sources = files([
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
])

libpn = shared_library(
    meson.project_name(),
    sources: libpn_sources,
    dependencies: deps,
    install: true,
    install_dir : [true, true, true]
)

libpn_dep = declare_dependency(
    link_with : libpn,
    include_directories: include_directories('.')
)

pkg.generate(
    libraries: libpn,
    requires : deps_str,
    version : '0',
    name : meson.project_name(),
    filebase : meson.project_name(),
    description : 'Library to interface easily with network connections'
)

install_data(
    'pantheon-networking.deps',
    install_dir: join_paths(get_option('datadir'), 'vala', 'vapi')
)

