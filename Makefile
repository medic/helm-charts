CHARTS := $(shell ls -1 charts/)

# Build targets
.PHONY: build
build: $(CHARTS:=/build) # Build dependencies for all charts
	@echo

$(CHARTS:=/build): add_repos # Build dependencies for a specific chart
	helm dependency build charts/$(@:/build=)

.PHONY: lint
lint: # Lint all charts
	helm lint charts/* --set cht_image_tag=unused_tag_for_chart_ci

.PHONY: template-validate-gcp
template-validate-gcp: build # Validate GCP templates can be rendered
	cd charts/cht-chart-4x && helm template . -f tests/gcp/test-values.yaml > /dev/null

.PHONY: schema-validate-gcp
schema-validate-gcp: build # Validate GCP resources against Kubernetes schemas
	cd charts/cht-chart-4x && helm template . -f tests/gcp/test-values.yaml | kubeval --ignore-missing-schemas

.PHONY: value-validate-gcp
value-validate-gcp: build # Validate required GCP resources are present
	cd charts/cht-chart-4x && helm template . -f tests/gcp/test-values.yaml | grep -q "kind: Service" || (echo "No Service found" && exit 1)
	cd charts/cht-chart-4x && helm template . -f tests/gcp/test-values.yaml | grep -q "kind: Deployment" || (echo "No Deployment found" && exit 1)

# Test gcp targets
.PHONY: test-gcp template-validate-gcp schema-validate-gcp value-validate-gcp
test-gcp: template-validate-gcp schema-validate-gcp value-validate-gcp # Run all GCP validations

# Repository targets
.PHONY: add_repos
add_repos: # Add helm repo dependencies for publishing charts
	helm repo add grafana                https://grafana.github.io/helm-charts
	helm repo add medic                  https://docs.communityhealthtoolkit.org/helm-charts
	helm repo add opencost               https://opencost.github.io/opencost-helm-chart
	helm repo add prometheus-community   https://prometheus-community.github.io/helm-charts
	helm repo add bitnami                https://charts.bitnami.com/bitnami
