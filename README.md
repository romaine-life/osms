# OSMS

Observability stack for `romaine.life`.

This repo owns:

- Loki and Alloy Kubernetes manifests (`k8s/loki`)
- Grafana Kubernetes manifests (`k8s/grafana`)
- OpenTofu-managed Azure resources for the observability stack (`tofu`)

`infra-bootstrap` should only point ArgoCD at these app paths; OSMS owns the
observability app internals and supporting cloud resources.
Observability stack for romaine.life: Loki, Grafana, and supporting Azure resources.
