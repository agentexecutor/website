---
title: CLI reference
description: Every ax verb, how it follows your kube context, and the global flags.
weight: 30
group: Start here
source: README.md#cli-usage
---

`ax` talks to the control plane over gRPC. It is deliberately `kubectl`-shaped: `apply`, `get`, `describe`, `watch`, `delete`, plus a few agent-specific verbs.

## Everyday commands

```bash
# Apply anything (multi-document YAML, file or stdin)
ax apply -f examples/task.yaml

# Tasks
ax get tasks                          # list
ax get tasks -a my-atespace           # list in another atespace
ax get task task123                   # full spec + live status as YAML
ax describe task task123              # human-readable detail
ax watch task task123                 # stream status and condition transitions
ax suspend task task123               # checkpoint actor state and pause
ax resume task task123                # resume a suspended task
ax delete task task123

# Shell into the running sandbox
ax ssh task123                        # interactive shell (task needs spec.debug: true)
ax ssh task123 -- ls -la /workspace   # one-off command
ax ssh task123 -- python3 main.py

# Gateways, workspaces, models follow the same pattern
ax get gateways
# NAME              ATESPACE   LISTENERS             EGRESS-HOSTS
# default-gateway   default    8494/gRPC,8080/HTTP   *
ax describe gateway default-gateway
ax delete gateway default-gateway

ax get workspaces
# NAME                ATESPACE   GIT-REPOS   MCP-SERVERS
# default-workspace   default    1           1
ax describe workspace default-workspace
ax delete workspace default-workspace

ax get models
# NAME            ATESPACE   PROVIDER   MODEL
# default-model   default    google     gemini-3.8-flash
ax describe model default-model
ax delete model default-model

# Connection plumbing
ax ctx                                # active kube context and how ax is reaching the control plane
ax tunnel list                        # background tunnels (state lives in ~/.ax/tunnels)
ax tunnel stop
ax version
```

## Works with `kubectx`

`ax` follows your active Kubernetes context. Switch clusters and `ax` resolves and tunnels to that cluster's control plane in the background.

```bash
kubectx staging-cluster
ax get tasks

kubectx prod-cluster
ax get tasks

# Or target a context without switching
ax --context=dev-cluster get tasks
```

## Global flags

| Flag | Description | Default |
|---|---|---|
| `-a`, `--atespace` | Atespace scope for the command | `default` |
| `-n`, `--namespace` | Kubernetes namespace where AX is installed | `ax-system` |
| `--context` | Kubernetes context to target | active `kubectx` / `current-context` |
| `--server` | Control plane address, bypassing auto-detection | derived from kube context, or `$AX_SERVER` |
