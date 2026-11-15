include yaml.mk
include makefile.mk
include shell.mk
include toml.mk
include markdown.mk
include actions.mk
include git.mk
include github.mk
include tools.mk
include help.mk

.DEFAULT_GOAL := help

.PHONY: format
format: format-yaml format-makefile format-shell format-toml format-markdown ## Format all files

.PHONY: lint
lint: lint-yaml lint-makefile lint-shell lint-markdown lint-actions ## Lint all files
