local PipelineBuild(os="linux", arch="amd64") = {
  kind: "pipeline",
  name: os + "-" + arch,
  platform: {
    os: os,
    arch: arch,
  },
  steps: [
    {
      name: "dryrun",
      image: "plugins/docker:" + os + "-" + arch,
      pull: "always",
      settings: {
        dry_run: true,
        tags: os + "-" + arch,
        dockerfile: "docker/Dockerfile." + os + "." + arch,
        repo: "plugins/base",
        username: { "from_secret": "docker_username" },
        password: { "from_secret": "docker_password" },
      },
      when: {
        event: [ "pull_request" ],
      },
    },
    {
      name: "publish",
      image: "plugins/docker:" + os + "-" + arch,
      pull: "always",
      settings: {
        auto_tag: true,
        auto_tag_suffix: os + "-" + arch,
        dockerfile: "docker/Dockerfile." + os + "." + arch,
        repo: "plugins/base",
        username: { "from_secret": "docker_username" },
        password: { "from_secret": "docker_password" },
      },
      when: {
        event: [ "push" ],
      },
    },
  ],
  trigger: {
    branch: [ "master" ],
  },
};

local PipelineMultiarch = {
  kind: "pipeline",
  name: "linux-multiarch",
  platform: {
    os: "linux",
    arch: "amd64",
  },
  steps: [
    {
      name: "dryrun",
      image: "plugins/docker:linux-amd64",
      pull: "always",
      settings: {
        dry_run: true,
        tags: [ "multiarch" ],
        dockerfile: "docker/Dockerfile.linux.multiarch",
        repo: "plugins/base",
        username: { "from_secret": "docker_username" },
        password: { "from_secret": "docker_password" },
      },
      when: {
        event: [ "pull_request" ],
      },
    },
    {
      name: "publish",
      image: "plugins/docker:linux-amd64",
      pull: "always",
      settings: {
        tags: [ "multiarch" ],
        dockerfile: "docker/Dockerfile.linux.multiarch",
        repo: "plugins/base",
        username: { "from_secret": "docker_username" },
        password: { "from_secret": "docker_password" },
      },
      when: {
        event: [ "push" ],
      },
    },
  ],
  trigger: {
    branch: [ "master" ],
  },
};

local PipelineNotifications = {
  kind: "pipeline",
  name: "notifications",
  platform: {
    os: "linux",
    arch: "amd64",
  },
  steps: [
    {
      name: "manifest",
      image: "plugins/manifest:1",
      pull: "always",
      settings: {
        username: { "from_secret": "docker_username" },
        password: { "from_secret": "docker_password" },
        spec: "docker/manifest.tmpl",
        ignore_missing: true,
      },
      when: {
        event: [ "push" ]
      }
    },
    {
      name: "microbadger",
      image: "plugins/webhook:1",
      pull: "always",
      settings: {
        url: { "from_secret": "microbadger_url" },
      },
      when: {
        event: [ "push" ]
      }
    },
  ],
  depends_on: [
    "linux-amd64",
    "linux-arm64",
    "linux-arm",
    "linux-multiarch",
  ],
  trigger: {
    branch: [ "master" ],
  },
};

[
    PipelineBuild("linux", "amd64"),
    PipelineBuild("linux", "arm64"),
    PipelineBuild("linux", "arm"),
    PipelineMultiarch,
    PipelineNotifications,
]
