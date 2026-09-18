ifndef YAML_MK_INCLUDED
YAML_MK_INCLUDED := 1

# Targets for formatting and linting YAML files.
#
# Optional variables (set before including this file):
#   YAML_FORMAT_PATH ?= .   # path passed to prettier
#   YAML_LINT_PATH   ?= .   # path passed to yamllint

YAML_FORMAT_PATH ?= .
YAML_LINT_PATH ?= .

# Directory pip --user tools may be installed into when not on PATH.
PYTHON_USER_BIN := $(shell python3 -m site --user-base 2>/dev/null)/bin
ifeq (,$(findstring $(PYTHON_USER_BIN),$(PATH)))
export PATH := $(PATH):$(PYTHON_USER_BIN)
endif

.PHONY: install-prettier
install-prettier:
	@if ! command -v prettier >/dev/null 2>&1; then \
		echo "📦 prettier not found, installing..."; \
		npm install -g prettier; \
	fi

.PHONY: format-yaml
format-yaml: install-prettier
	@echo "✨ Running prettier to format YAML files..."
	prettier --write $(YAML_FORMAT_PATH)
	@echo "✅ Prettier formatting complete"

.PHONY: install-yamllint
install-yamllint:
	@if ! command -v yamllint >/dev/null 2>&1; then \
		echo "📦 yamllint not found, installing..."; \
		if command -v pipx >/dev/null 2>&1; then \
			pipx install yamllint; \
		else \
			pip3 install --user --break-system-packages yamllint; \
		fi; \
	fi

.PHONY: lint-yaml
lint-yaml: install-yamllint
	@echo "🔍 Running yamllint on YAML files..."
	yamllint -f colored $(YAML_LINT_PATH)
	@echo "✅ Yamllint passed"

endif
