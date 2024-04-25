.PHONY: test
test:
	helm lint charts/* --set cht_image_tag=unused_tag_for_chart_ci

.PHONY: add_repos
add_repos: # Add helm repo dependencies for publishing charts
	helm repo add airbyte                https://airbytehq.github.io/helm-charts
	helm repo add grafana                https://grafana.github.io/helm-charts
	helm repo add influxdata             https://helm.influxdata.com/
	helm repo add medic                  https://docs.communityhealthtoolkit.org/helm-charts
	helm repo add oauth2-proxy           https://oauth2-proxy.github.io/manifests
	helm repo add opencost               https://opencost.github.io/opencost-helm-chart
	helm repo add prometheus-community   https://prometheus-community.github.io/helm-charts
	helm repo add superset               https://apache.github.io/superset
	helm repo add vector                 https://helm.vector.dev
