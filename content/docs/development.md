---
title: Development
description: Build, test, and ship changes to AX itself.
weight: 90
group: Internals
source: docs/development.md
---

## Prerequisites

- Go 1.27+
- [`ko`](https://ko.build/) for building and deploying control plane images
- Docker or Podman for the task runner image
- A Kubernetes cluster and kubeconfig

## Build

```bash
make build                 # bin/ax, bin/ax-controller, bin/ax-server
make install               # install the ax CLI into $(go env GOPATH)/bin
make build-task-runner     # cross-compile the runner for linux/amd64 and build its image
make push-task-runner      # ...and push it (set TASK_RUNNER_REPO)
```

## Test

Runs everything, including the mock Substrate gRPC server, in-memory store validation, and API server tests:

```bash
make test        # or: go test -v ./...
```

## Contributing

AX is released under the Apache License 2.0. Source, issues, and pull requests live on [GitHub](https://github.com/google/ax).
