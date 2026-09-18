ifndef YAML_MK_INCLUDED
YAML_MK_INCLUDED := 1

# Targets for formatting and linting YAML files.
#
# Optional variables (set before including this file):
#   YAML_FORMAT_PATH ?= .   # path passed to prettier
#   YAML_LINT_PATH   ?= .   # path passed to yamllint

YAML_FORMAT_PATH ?= .
YAML_LINT_PATH ?= .

.PHONY: format-yaml
format-yaml:
	@echo "✨ Running prettier to format YAML files..."
	prettier --write $(YAML_FORMAT_PATH)
	@echo "✅ Prettier formatting complete"

.PHONY: lint-yaml
lint-yaml:
	@echo "🔍 Running yamllint on YAML files..."
	yamllint -f colored $(YAML_LINT_PATH)
	@echo "✅ Yamllint passed"

endif
