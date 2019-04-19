local pipeline = import 'pipeline.libsonnet';
local name = 'drone-base';

local PipelineMultiarch = {
  kind: 'pipeline',
  name: 'linux-multiarch',
  platform: {
    os: 'linux',
    arch: 'amd64',
  },
  steps: [
    {
      name: 'dryrun',
      image: 'plugins/docker:linux-amd64',
      pull: 'always',
      settings: {
        dry_run: true,
        tags: ['multiarch'],
        dockerfile: 'docker/Dockerfile.linux.multiarch',
        repo: 'plugins/base',
        username: { from_secret: 'docker_username' },
        password: { from_secret: 'docker_password' },
      },
      when: {
        event: ['pull_request'],
      },
    },
    {
      name: 'publish',
      image: 'plugins/docker:linux-amd64',
      pull: 'always',
      settings: {
        tags: ['multiarch'],
        dockerfile: 'docker/Dockerfile.linux.multiarch',
        repo: 'plugins/base',
        username: { from_secret: 'docker_username' },
        password: { from_secret: 'docker_password' },
      },
      when: {
        event: ['push'],
      },
    },
  ],
  trigger: {
    branch: ['master'],
  },
};

[
  pipeline.build(name, 'linux', 'amd64'),
  pipeline.build(name, 'linux', 'arm64'),
  pipeline.build(name, 'linux', 'arm'),
  PipelineMultiarch,
  pipeline.notifications(depends_on=[
    'linux-amd64',
    'linux-arm64',
    'linux-arm',
    'linux-multiarch',
  ]),
]
