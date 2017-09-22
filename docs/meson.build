valadoc = find_program('valadoc')

packages_command = []
foreach dep_str : deps_str
    packages_command += ['--pkg', dep_str]
endforeach

basic_command = [
    valadoc,
    '--force',
    '--verbose',
    '--package-name', meson.project_name(),
    '--package-version', meson.project_version(),
    '--driver', meson.get_compiler('vala').version(),
    packages_command,
    '--vapidir=' + join_paths(meson.build_root(), 'lib'),
    '--vapidir=' + join_paths(meson.source_root(), 'vapi'),
    '--importdir=' + join_paths('/usr', 'share', 'gtk-doc', 'html'),
    '--doclet=html',
    '--use-svg-images'
]

doc_target = custom_target(
    'library documentation',
    command: [
        basic_command,
        '-o', '@OUTPUT@',
        '@INPUT@'
    ],
    build_by_default: true,
    input: libpn_sources,
    output: ''
)
