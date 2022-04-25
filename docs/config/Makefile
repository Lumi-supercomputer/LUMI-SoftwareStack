all: preview

build:
	mkdocs build

deploy-origin:
	mkdocs gh-deploy --force --remote-name origin

deploy-upstream:
	mkdocs gh-deploy --force --remote-name upstream

check test:
	mkdocs build --strict

serve preview:
	mkdocs serve
