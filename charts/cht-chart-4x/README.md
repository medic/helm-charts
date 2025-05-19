# CHT Chart 4.x

This chart deploys the Community Health Toolkit (CHT) 4.x on Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installation

```bash
# Add the Medic Helm repository
helm repo add medic https://docs.communityhealthtoolkit.org/helm-charts
helm repo update

# Install the chart
helm install my-release medic/cht-chart-4x
```

## GCP Deployment

### Prerequisites
- Google Cloud Platform (GCP) account with billing enabled
- gcloud CLI installed and configured

### GCP-Specific Configuration

The following GCP-specific parameters can be configured in `values-gcp.yaml`:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `cluster_type` | Cluster type | `"gke"` |
| `cert_source` | Certificate source | `"gcp-managed"` |
| `ingress.gcp.staticIpName` | Static IP name | `"api-ip"` |
| `ingress.gcp.managedCertificateName` | Managed certificate name | `"api-cert"` |

## Testing

To run the GCP-specific tests:

```bash
make test-gcp
```

This will:
1. Validate templates can be rendered
2. Validate Kubernetes schemas
3. Verify required resources are present
