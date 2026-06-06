<div align="center">

<img src="https://github.com/kubernetes/kubernetes/raw/master/logo/logo.svg" align="center" width="144px" height="144px"/>

### My _geeked_ homelab k8s cluster

_... automated via [Flux](https://github.com/fluxcd/flux2), [Renovate](https://github.com/renovatebot/renovate), and [GitHub Actions](https://github.com/features/actions)_

</div>

<div align="center">

![Talos](https://kromgo.nlecoy.fr/badges/talos_version)&nbsp;&nbsp;
![Kubernetes](https://kromgo.nlecoy.fr/badges/kubernetes_version)&nbsp;&nbsp;
![Flux](https://kromgo.nlecoy.fr/badges/flux_version)&nbsp;&nbsp;
![Renovate](https://img.shields.io/github/actions/workflow/status/nlecoy/home-ops/renovate.yaml?branch=main&label&logo=renovate&color=blue)

</div>

<div align="center">

![Age](https://kromgo.nlecoy.fr/badges/cluster_birth_age)&nbsp;&nbsp;
![Uptime](https://kromgo.nlecoy.fr/badges/cluster_uptime_age)&nbsp;&nbsp;
![Nodes](https://kromgo.nlecoy.fr/badges/cluster_node_count)&nbsp;&nbsp;
![Pods](https://kromgo.nlecoy.fr/badges/cluster_pod_count)&nbsp;&nbsp;
![CPU](https://kromgo.nlecoy.fr/badges/cluster_cpu_usage)&nbsp;&nbsp;
![Memory](https://kromgo.nlecoy.fr/badges/cluster_memory_usage)&nbsp;&nbsp;
![Alerts](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.nlecoy.fr%2Fcluster_alert_count&style=flat-square&label=Alerts)

</div>


## Overview

This is a repository for my Kubernetes cluster. I try to adhere to Infrastructure as Code (IaC) and GitOps practices using tools like [Kubernetes](https://github.com/kubernetes/kubernetes), [Flux](https://github.com/fluxcd/flux2), [Renovate](https://github.com/renovatebot/renovate), and [GitHub Actions](https://github.com/features/actions).

### Core Components

- [actions-runner-controller](https://github.com/actions/actions-runner-controller): Self-hosted GitHub runners for CI/CD workflows.
- [cert-manager](https://github.com/cert-manager/cert-manager): Automated SSL certificate management and provisioning.
- [cilium](https://github.com/cilium/cilium): High-performance container networking powered by [eBPF](https://ebpf.io).
- [cloudflared](https://github.com/cloudflare/cloudflared): Secure tunnel providing Cloudflare-protected access to cluster services.
- [envoy-gateway](https://github.com/envoyproxy/gateway): Modern ingress controller for cluster traffic management.
- [external-dns](https://github.com/kubernetes-sigs/external-dns): Automated DNS record synchronization for ingress resources.
- [external-secrets](https://github.com/external-secrets/external-secrets): Kubernetes secrets management integrated with [1Password Connect](https://github.com/1Password/connect).

### GitOps

[Flux](https://github.com/fluxcd/flux2) watches my [kubernetes](./kubernetes) folder (see Directories below) and makes the changes to my clusters based on the state of my Git repository.

The way Flux works for me here is it will recursively search the [kubernetes/apps](./kubernetes/apps) folder until it finds the most top level `kustomization.yaml` per directory and then apply all the resources listed in it. That aforementioned `kustomization.yaml` will generally only have a namespace resource and one or many Flux kustomizations (`install.yaml`). Under the control of those Flux kustomizations there will be a `HelmRelease` or other resources related to the application which will be applied.

[Renovate](https://github.com/renovatebot/renovate) monitors my **entire** repository for dependency updates, automatically creating a PR when updates are found. When some PRs are merged Flux applies the changes to my cluster.

### Directories

This Git repository contains the following directories under [kubernetes](./kubernetes).

```sh
📁 kubernetes      # Kubernetes cluster defined as code
├─📁 apps          # Apps deployed into my cluster grouped by namespace (see below)
├─📁 components    # Re-usable kustomize components
└─📁 flux          # Flux system configuration
```

## Hardware


| Device                      | Num | OS Disk Size | Data Disk Size                  | Ram  | OS            | Function                |
|-----------------------------|-----|--------------|---------------------------------|------|---------------|-------------------------|
| Beelink EQi12   | 1   | 500GB SSD      | 1TB (local) | 32GB | Talos         | Kubernetes              |
| UNAS 2         | 1   | -      | 2x2TB ZFS (mirrored vdevs)     | 4GB | - | NFS + Backup Server     |
| Express 7              | 1   | -            | -                       | -    | -             | Router            |
| Flex Mini | 1   | -            | -                               | -    | -             | 1Gb Switch        |

## Networking

- Default: 10.0.1.0/24
- Trusted: 10.0.10.0/24
- Servers: 10.0.20.0/24
- Service: 10.0.30.0/24
- IoT: 10.0.40.0/24
