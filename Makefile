.PHONY: test
test:
	helm lint charts/* --set cht_image_tag=unused_tag_for_chart_ci

.PHONY: add_repos
add_repos: # Add helm repo dependencies for publishing charts
	helm repo add medic https://docs.communityhealthtoolkit.org/helm-charts
