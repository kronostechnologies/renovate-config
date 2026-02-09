BASE_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

# renovate: datasource=npm depName=renovate
RENOVATE_VERSION := 43.4.5

setup_asdf = ./bin/setup_asdf.bash
exit_error = (>&2 echo -e ">> \x1B[31m$1\x1B[39m" && exit 1)

.PHONY: setup
setup:
	@$(setup_asdf)

.PHONY: check
check: check.workflows check.renovate

.PHONY: check.workflows
check.workflows:
	@actionlint -color

.PHONY: check.renovate
check.renovate:
	@npx --package="renovate@${RENOVATE_VERSION}" -- renovate-config-validator --strict .github/renovate.json5 default.json authenticated.json5 base.json5

.PHONY: test
test:

.PHONY: compile
compile:

.PHONY: package
package:

.PHONY: all
all: setup check test compile package
.DEFAULT_GOAL := all
