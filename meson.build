project ('pantheon-networking', ['vala', 'c'], version: '1.0')

pkg = import('pkgconfig')
i18n = import('i18n')
add_project_arguments('-DGETTEXT_PACKAGE="' + meson.project_name() + '"', language:'c')

libnm_dep = meson.get_compiler('vala').find_library('libnm', required: false)
if not libnm_dep.found()
    add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')
endif

# required to create the documentation and the .pc file
deps_str = [
    'gobject-2.0',
    'glib-2.0',
    'gio-2.0',
    'gtk+-3.0',
    'gee-0.8',
    'libnm'
]

deps = [
  dependency('gobject-2.0'),
  dependency('glib-2.0'),
  dependency('gio-2.0'),
  dependency('gtk+-3.0'),
  dependency('gee-0.8'),
  dependency('libnm')
]

subdir('lib')

if (get_option('documentation'))
    subdir('docs')
endif

if (get_option('examples'))
    subdir('examples')
endif
