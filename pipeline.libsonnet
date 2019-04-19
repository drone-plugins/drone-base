local windows_pipe = '\\\\\\\\.\\\\pipe\\\\docker_engine';
local windows_pipe_volume = 'docker_pipe';

local windows(os) = os == 'windows';

{
  build(name, os='linux', arch='amd64', version='')::
    local is_windows = windows(os);
    local tag = if is_windows then os + '-' + version else os + '-' + arch;
    local file_suffix = std.strReplace(tag, '-', '.');
    local volumes = if is_windows then [{ name: windows_pipe_volume, path: windows_pipe }] else [];
    local plugin_repo = 'plugins/' + std.splitLimit(name, '-', 1)[1];
    local extension = if is_windows then '.exe' else '';
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
            daemon_off: if is_windows then 'true' else 'false',
            repo: plugin_repo,
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
            daemon_off: if is_windows then 'true' else 'false',
            dockerfile: 'docker/Dockerfile.' + file_suffix,
            repo: plugin_repo,
            username: { from_secret: 'docker_username' },
            password: { from_secret: 'docker_password' },
          },
          volumes: if std.length(volumes) > 0 then volumes,
          when: {
            event: {
              exclude: ['pull_request'],
            },
          },
        },
      ],
      trigger: {
        ref: [
          'refs/heads/master',
          'refs/tags/**',
          'refs/pull/**',
        ],
      },
      volumes: if is_windows then [{ name: windows_pipe_volume, host: { path: windows_pipe } }],
    },

  notifications(os='linux', arch='amd64', version='', depends_on=[])::
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
          image: 'plugins/manifest',
          pull: 'always',
          settings: {
            username: { from_secret: 'docker_username' },
            password: { from_secret: 'docker_password' },
            spec: 'docker/manifest.tmpl',
            ignore_missing: true,
            auto_tag: true,
          },
        },
        {
          name: 'microbadger',
          image: 'plugins/webhook',
          pull: 'always',
          settings: {
            urls: { from_secret: 'microbadger_url' },
          },
        },
      ],
      trigger: {
        ref: [
          'refs/heads/master',
          'refs/tags/**',
        ],
      },
      depends_on: depends_on,
    },
}
