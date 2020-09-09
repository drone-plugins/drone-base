def main(ctx):
  stages = [
    multiarch(),
    linux('amd64'),
    linux('arm64'),
    linux('arm'),
    windows('1903'),
    windows('1809'),
  ]

  after = manifest() + gitter()

  for s in stages:
    for a in after:
      a['depends_on'].append(s['name'])

  return stages + after

def multiarch():
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'linux-multiarch',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'steps': [
      {
        'name': 'dryrun',
        'image': 'plugins/docker',
        'pull': 'always',
        'settings': {
          'dry_run': True,
          'tags': 'multiarch',
          'dockerfile': 'docker/Dockerfile.linux.multiarch',
          'repo': 'plugins/base',
          'username': {
            'from_secret': 'docker_username'
          },
          'password': {
            'from_secret': 'docker_password'
          }
        },
        'when': {
          'event': [
            'pull_request'
          ]
        }
      },
      {
        'name': 'publish',
        'image': 'plugins/docker',
        'pull': 'always',
        'settings': {
          'tags': 'multiarch',
          'dockerfile': 'docker/Dockerfile.linux.multiarch',
          'repo': 'plugins/base',
          'username': {
            'from_secret': 'docker_username'
          },
          'password': {
            'from_secret': 'docker_password'
          }
        },
        'when': {
          'event': {
            'exclude': [
              'pull_request'
            ]
          }
        }
      }
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
        'refs/pull/**'
      ]
    }
  }

def linux(arch):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'linux-%s' % arch,
    'platform': {
      'os': 'linux',
      'arch': arch,
    },
    'steps': [
      {
        'name': 'dryrun',
        'image': 'plugins/docker',
        'pull': 'always',
        'settings': {
          'dry_run': True,
          'tags': 'linux-%s' % arch,
          'dockerfile': 'docker/Dockerfile.linux.%s' % arch,
          'repo': 'plugins/base',
          'username': {
            'from_secret': 'docker_username'
          },
          'password': {
            'from_secret': 'docker_password'
          }
        },
        'when': {
          'event': [
            'pull_request'
          ]
        }
      },
      {
        'name': 'publish',
        'image': 'plugins/docker',
        'pull': 'always',
        'settings': {
          'auto_tag': True,
          'auto_tag_suffix': 'linux-%s' % arch,
          'dockerfile': 'docker/Dockerfile.linux.%s' % arch,
          'repo': 'plugins/base',
          'username': {
            'from_secret': 'docker_username'
          },
          'password': {
            'from_secret': 'docker_password'
          }
        },
        'when': {
          'event': {
            'exclude': [
              'pull_request'
            ]
          }
        }
      }
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
        'refs/pull/**'
      ]
    }
  }

def windows(version):
  return {
    'kind': 'pipeline',
    'type': 'ssh',
    'name': 'windows-%s' % version,
    'platform': {
      'os': 'windows'
    },
    'server': {
      'host': {
        'from_secret': 'windows_server_%s' % version
      },
      'user': {
        'from_secret': 'windows_username'
      },
      'password': {
        'from_secret': 'windows_password'
      },
    },
    'steps': [
      {
        'name': 'latest',
        'environment': {
          'USERNAME': {
            'from_secret': 'docker_username'
          },
          'PASSWORD': {
            'from_secret': 'docker_password'
          },
        },
        'commands': [
          'echo $env:PASSWORD | docker login --username $env:USERNAME --password-stdin',
          'docker build --pull -f docker/Dockerfile.windows.%s -t plugins/base:windows-%s-amd64 .' % (version, version),
          'docker push plugins/base:windows-%s-amd64' % version,
        ],
        'when': {
          'ref': [
            'refs/heads/master',
          ]
        }
      },
      {
        'name': 'tagged',
        'environment': {
          'USERNAME': {
            'from_secret': 'docker_username'
          },
          'PASSWORD': {
            'from_secret': 'docker_password'
          },
        },
        'commands': [
          'echo $env:PASSWORD | docker login --username $env:USERNAME --password-stdin',
          'docker build --pull -f docker/Dockerfile.windows.%s -t plugins/base:${DRONE_TAG##v}-windows-%s-amd64 .' % (version, version),
          'docker push plugins/base:${DRONE_TAG##v}-windows-%s-amd64' % version,
        ],
        'when': {
          'ref': [
            'refs/tags/**',
          ]
        }
      }
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ]
    }
  }

def manifest():
  return [{
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'manifest',
    'steps': [
      {
        'name': 'manifest',
        'image': 'plugins/manifest',
        'pull': 'always',
        'settings': {
          'auto_tag': 'true',
          'username': {
            'from_secret': 'docker_username'
          },
          'password': {
            'from_secret': 'docker_password'
          },
          'spec': 'docker/manifest.tmpl',
          'ignore_missing': 'true',
        },
      },
      {
        'name': 'microbadger',
        'image': 'plugins/webhook',
        'pull': 'always',
        'settings': {
          'urls': {
            'from_secret': 'microbadger_url'
          }
        },
      }
    ],
    'depends_on': [],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**'
      ]
    }
  }]

def gitter():
  return [{
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'gitter',
    'clone': {
      'disable': True
    },
    'steps': [
      {
        'name': 'gitter',
        'image': 'plugins/gitter',
        'pull': 'always',
        'settings': {
          'webhook': {
            'from_secret': 'gitter_webhook'
          }
        },
      },
    ],
    'depends_on': [
      'manifest'
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
        'refs/pull/**'
      ],
      'status': [
        'failure'
      ]
    }
  }]
