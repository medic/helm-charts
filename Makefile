CHARTS := $(shell ls -1 charts/)

.PHONY: build
build: $(CHARTS:=/build) # Build dependencies for all charts
	@echo

$(CHARTS:=/build): add_repos # Build dependencies for a specific chart
	helm dependency build charts/$(@:/build=)

.PHONY: lint test
lint: # Lint all charts
	helm lint charts/* --set cht_image_tag=unused_tag_for_chart_ci

test: build # Validate GCP templates
	helm template . -f charts/cht-chart-4x/tests/gcp/test-values.yaml | kubeval

.PHONY: add_repos
add_repos: # Add helm repo dependencies for publishing charts
	helm repo add grafana                https://grafana.github.io/helm-charts
	helm repo add medic                  https://docs.communityhealthtoolkit.org/helm-charts
	helm repo add opencost               https://opencost.github.io/opencost-helm-chart
	helm repo add prometheus-community   https://prometheus-community.github.io/helm-charts
	helm repo add bitnami                https://charts.bitnami.com/bitnami
