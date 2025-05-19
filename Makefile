CHARTS := $(shell ls -1 charts/)

.PHONY: build
build: $(CHARTS:=/build) # Build dependencies for all charts
	@echo

$(CHARTS:=/build): add_repos # Build dependencies for a specific chart
	helm dependency build charts/$(@:/build=)

.PHONY: lint test template-validate schema-validate value-validate
lint: # Lint all charts
	helm lint charts/* --set cht_image_tag=unused_tag_for_chart_ci

template-validate: build # Validate templates can be rendered
	cd charts/cht-chart-4x && helm template . -f tests/gcp/test-values.yaml > /dev/null

schema-validate: build # Validate against Kubernetes schemas
	cd charts/cht-chart-4x && helm template . -f tests/gcp/test-values.yaml | kubeval --schema-location https://kubernetesjsonschema.dev/master-standalone/ --schema-location file://$(PWD)/charts/cht-chart-4x/tests/gcp/schemas

value-validate: build # Validate required resources are present
	cd charts/cht-chart-4x && helm template . -f tests/gcp/test-values.yaml | grep -q "kind: Service" || (echo "No Service found" && exit 1)
	cd charts/cht-chart-4x && helm template . -f tests/gcp/test-values.yaml | grep -q "kind: Deployment" || (echo "No Deployment found" && exit 1)

test: lint template-validate schema-validate value-validate # Run all validations

.PHONY: add_repos
add_repos: # Add helm repo dependencies for publishing charts
	helm repo add grafana                https://grafana.github.io/helm-charts
	helm repo add medic                  https://docs.communityhealthtoolkit.org/helm-charts
	helm repo add opencost               https://opencost.github.io/opencost-helm-chart
	helm repo add prometheus-community   https://prometheus-community.github.io/helm-charts
	helm repo add bitnami                https://charts.bitnami.com/bitnami
