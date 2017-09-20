examples_sources = [
  'ListDevices.vala',
  meson.build_root() + '/lib/' + meson.project_name() + '.vapi'
]

examples_deps = [
  dependency('gee-0.8'),
  dependency('gio-2.0'),
  dependency('libnm'),
]

vala_args = [
  '-X', '-lpantheon-networking'
]

executable(
  'list-devices',
  sources: examples_sources,
  dependencies: examples_deps,
  vala_args: vala_args,
  install: false)
