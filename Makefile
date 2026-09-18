include yaml.mk
include makefile.mk
include shell.mk

.PHONY: install-tools
install-tools: install-prettier install-yamllint install-mbake install-checkmake install-shellcheck install-shfmt

.PHONY: format
format: format-yaml format-makefile format-shell

.PHONY: lint
lint: lint-yaml lint-makefile lint-shell