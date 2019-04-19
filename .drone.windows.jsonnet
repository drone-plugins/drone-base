local pipeline = import 'pipeline.libsonnet';
local name = 'drone-base';

[
  pipeline.build(name, 'windows', 'amd64', '1803'),
  pipeline.build(name, 'windows', 'amd64', '1809'),
  pipeline.notifications('windows', 'amd64', '1809', ['windows-1803', 'windows-1809']),
]
