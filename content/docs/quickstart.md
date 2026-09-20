---
title: Quick start
description: Install the CLI, deploy the control plane, and run your first sandboxed task.
weight: 10
group: Start here
source: README.md#quick-start
---

## 1. Install the CLI

```bash
go install github.com/google/ax/cmd/ax@latest
```

This puts the `ax` binary in `$(go env GOPATH)/bin`. Make sure that directory is on your `PATH`.

## 2. Deploy the control plane

You need a Kubernetes cluster, [`ko`](https://ko.build/) (`brew install ko`), a container registry your cluster can pull from, and a reachable Agent Substrate Control API (in-cluster default: `api.ate-system.svc.cluster.local:443`).

```bash
make deploy AX_IMAGE_REPO=<your-registry>
```

This deploys Redis, then builds and deploys the control plane images with `ko`. Everything lands in the `ax-system` namespace.

## 3. Run your first task

Write a `Workspace` that clones a repository and a `Task` that binds it. The `goal` on the binding tells the runner what a ready environment looks like; an agent finishes the setup on first boot.

```yaml
# task.yaml
apiVersion: ax.io/v1alpha1
kind: Workspace
metadata:
  name: golang
spec:
  git:
    - repo: https://github.com/golang/go.git
      branch: "my-fix"
---
apiVersion: ax.io/v1alpha1
kind: Task
metadata:
  name: test
spec:
  workspaces:
    - name: golang
      goal: "Ensure that Go tool chain is available and is built from source"
  debug: true   # enable ssh'ing
```

Then apply it, watch it come up, and look over the agent's shoulder:

```bash
ax apply -f task.yaml
ax watch task test
ax ssh test -- ls -al /workspace
```

The repository also ships a complete example with a `Task`, `Workspace`, `Gateway`, and `Model` in one file:

```bash
ax apply -f examples/task.yaml       # Task + Workspace + Gateway + Model in one file
ax get tasks
# NAME      ATESPACE   PHASE     ACTOR           WORKER-IP    AGE
# task123   default    Running   task123         10.20.3.67   1m

ax watch task task123                # stream phase and condition changes live
ax ssh task123 -- ls -la /workspace  # poke around inside the sandbox
ax suspend task task123              # checkpoint and pause
ax resume task task123               # pick up where it left off
```

Want to see the whole lifecycle end to end? Run [`./demo.sh`](https://github.com/google/ax/blob/main/demo.sh). It applies a custom workspace, waits for readiness, runs commands over `ax ssh`, and suspends the task.

## Next steps

- Learn what each resource does in [Concepts]({{< relref "concepts" >}}).
- Write your own YAML with the annotated examples in [Manifests]({{< relref "manifests" >}}).
- See every verb the CLI supports in the [CLI reference]({{< relref "cli" >}}).
