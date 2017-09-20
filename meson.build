project ('pantheon-networking', ['vala', 'c'],
        version: '0.1')

libnm_dep = meson.get_compiler('vala').find_library('libnm', required: false)
if not libnm_dep.found()
    add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')
endif

deps = [
  dependency('gtk+-3.0'),
  dependency('gobject-2.0'),
  dependency('gee-0.8'),
  dependency('libnm')
]

i18n = import('i18n')
libpn_api_ver = '1.0'

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

subdir('lib')
# subdir('examples')
