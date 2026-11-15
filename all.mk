ifndef ALL_MK_INCLUDED
ALL_MK_INCLUDED := 1

# Aggregate targets that run every format/lint module of this repo.
#
# `format` runs `format-yaml`, `format-makefile`, `format-shell`, `format-toml` and
# `format-markdown`; `lint` runs `lint-yaml`, `lint-makefile`, `lint-shell`, `lint-markdown` and
# `lint-actions`. This file includes those modules, so including it is enough. A consumer that
# needs only some of them should include them directly and define its own `format`/`lint`.

_ALL_MK_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(_ALL_MK_DIR)yaml.mk
include $(_ALL_MK_DIR)makefile.mk
include $(_ALL_MK_DIR)shell.mk
include $(_ALL_MK_DIR)toml.mk
include $(_ALL_MK_DIR)markdown.mk
include $(_ALL_MK_DIR)actions.mk

.PHONY: format
format: format-yaml format-makefile format-shell format-toml format-markdown ## Format all files

.PHONY: lint
lint: lint-yaml lint-makefile lint-shell lint-markdown lint-actions ## Lint all files

endif
