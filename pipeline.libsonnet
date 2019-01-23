{
  build(os='linux', arch='amd64', version='')::
    local tag = if os == 'windows' then os + '-' + version else os + '-' + arch;
    local file_suffix = std.strReplace(tag, '-', '.');
    local volumes = if os == 'windows' then [{ name: 'docker_pipe', path: '//./pipe/docker_engine' }] else [];
    {
      kind: 'pipeline',
      name: tag,
      platform: {
        os: os,
        arch: arch,
        version: if std.length(version) > 0 then version,
      },
      steps: [
        {
          name: 'dryrun',
          image: 'plugins/docker:' + tag,
          pull: 'always',
          settings: {
            dry_run: true,
            tags: tag,
            dockerfile: 'docker/Dockerfile.' + file_suffix,
            repo: 'plugins/base',
            username: { from_secret: 'docker_username' },
            password: { from_secret: 'docker_password' },
          },
          volumes: if std.length(volumes) > 0 then volumes,
          when: {
            event: ['pull_request'],
          },
        },
        {
          name: 'publish',
          image: 'plugins/docker:' + tag,
          pull: 'always',
          settings: {
            auto_tag: true,
            auto_tag_suffix: tag,
            dockerfile: 'docker/Dockerfile.' + file_suffix,
            repo: 'plugins/base',
            username: { from_secret: 'docker_username' },
            password: { from_secret: 'docker_password' },
          },
          volumes: if std.length(volumes) > 0 then volumes,
          when: {
            event: ['push'],
          },
        },
      ],
      trigger: {
        branch: ['master'],
      },
      volumes: if os == 'windows' then [{ name: 'docker_pipe', host: { path: '//./pipe/docker_engine' } }],
    },

  notifications(os='linux', arch='amd64', version='', depends_on=[])::
    local tag = if os == 'windows' then os + '-' + version else os + '-' + arch;
    {
      kind: 'pipeline',
      name: 'notifications',
      platform: {
        os: os,
        arch: arch,
        version: if std.length(version) > 0 then version,
      },
      steps: [
        {
          name: 'manifest',
          image: 'plugins/manifest:' + tag,
          pull: 'always',
          settings: {
            username: { from_secret: 'docker_username' },
            password: { from_secret: 'docker_password' },
            spec: 'docker/manifest.tmpl',
            ignore_missing: true,
          },
          when: {
            event: ['push'],
          },
        },
        {
          name: 'microbadger',
          image: 'plugins/webhook:' + tag,
          pull: 'always',
          settings: {
            url: { from_secret: 'microbadger_url' },
          },
          when: {
            event: ['push'],
          },
        },
      ],
      depends_on: depends_on,
      trigger: {
        branch: ['master'],
      },
    },
}
