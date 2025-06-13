# CHT Chart 4.x

This chart deploys the Community Health Toolkit (CHT) 4.x on Kubernetes.

## Step-by-Step Testing GCP Deployment Guide

### Prerequisites
- Google Cloud Platform (GCP) account with billing enabled
- gcloud CLI installed and configured
- kubectl configured to access your GKE cluster
- Helm installed

### ⚠️ Cost Considerations

- Running this test environment in GCP will incur costs.
- Always clean up resources when done testing to avoid unnecessary charges.
- Use smaller machine types for testing.
- Monitor your GCP billing dashboard.
- Set up budget alerts in GCP.

For the most up-to-date pricing, check the [GCP Pricing Calculator](https://cloud.google.com/products/calculator).

1. **Install the chart using one of these methods:**

   **Option 1 - Using Helm Repository (Recommended):**
   ```bash
   # Add the Medic Helm repository
   helm repo add medic https://medic.github.io/helm-charts
   helm repo update

   # Install the chart
   helm install cht-test medic/cht-chart-4x --namespace cht-gcp-test -f values.yaml -f values-gcp.yaml -f tests/gcp/test-values.yaml
   ```

   **Option 2 - Using Git Clone:**
   ```bash
   git clone https://github.com/medic/helm-charts.git
   cd helm-charts/charts/cht-chart-4x
   helm install cht-test . --namespace cht-gcp-test -f values.yaml -f values-gcp.yaml -f tests/gcp/test-values.yaml
   ```

2. **Create a namespace for your deployment:**
   ```bash
   kubectl create namespace cht-gcp-test
   ```

3. **Reserve a static IP in GCP:**
   ```bash
   # Create a static IP
   gcloud compute addresses create test-api-ip --global

   # Get the IP address
   gcloud compute addresses describe test-api-ip --global --format='get(address)'
   ```
   - Save the IP address for the next step
   - This IP will be used in your nip.io domain

4. **Configure the deployment:**
   - Review and modify `tests/gcp/test-values.yaml` for test-specific settings:
     ```yaml
     ingress:
       host: "<YOUR-STATIC-IP>.nip.io"  # Replace with your static IP
     ```

5. **Deploy the chart:**
   ```bash
   helm install cht-test . --namespace cht-gcp-test -f values.yaml -f values-gcp.yaml -f tests/gcp/test-values.yaml
   ```

6. **Verify the deployment:**
   ```bash
   # Check pods
   kubectl get pods -n cht-gcp-test

   # Check services
   kubectl get services -n cht-gcp-test

   # Check ingress
   kubectl get ingress -n cht-gcp-test
   ```

7. **Access the application:**
   - The application will be available at: `http://<YOUR-STATIC-IP>.nip.io/medic`
   - Use the static IP you reserved in step 3

8. **Application Access:**
   - The application is accessible at `/medic` path
   - If you get a "Not Found" error at the root path, this is expected
   - Always use `http://<YOUR-STATIC-IP>.nip.io/medic`

### Cleanup Steps

When you're done testing, follow these steps to clean up all resources:

1. **Delete the Helm release:**
   ```bash
   helm uninstall cht-test -n cht-gcp-test
   ```

2. **Delete the namespace:**
   ```bash
   kubectl delete namespace cht-gcp-test
   ```

3. **Release the static IP:**
   ```bash
   gcloud compute addresses delete test-api-ip --global
   ```

4. **Verify cleanup:**
   ```bash
   # Check if namespace is deleted
   kubectl get namespace cht-gcp-test

   # Check if static IP is released
   gcloud compute addresses list --global
   ```

### ⚠️ Important Notes

1. **HTTP Only for Testing:**
   - This deployment uses HTTP only for testing purposes
   - Managed certificates are disabled because nip.io domains are not suitable for certificate verification
   - For production, use a real domain name and enable HTTPS

2. **Production Considerations:**
   - Use a real domain name
   - Set up proper DNS records
   - Enable HTTPS with managed certificates
   - Configure proper security settings
   - Use production-grade credentials

## Automated Validation/Testing

To run the GCP-specific tests:

```bash
make test-gcp
```

This will:
1. Validate templates can be rendered
2. Validate Kubernetes schemas
3. Verify required resources are present
