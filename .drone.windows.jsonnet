local pipeline = import 'pipeline.libsonnet';

[
  pipeline.build('windows', 'amd64', '1803'),
  pipeline.build('windows', 'amd64', '1809'),
  pipeline.notifications('windows', 'amd64', '1809', ['windows-1803', 'windows-1809']),
]
