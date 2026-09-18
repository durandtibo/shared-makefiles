ifndef SHELL_MK_INCLUDED
SHELL_MK_INCLUDED := 1

# Targets for formatting and linting shell scripts.
#
# Optional variables (set before including this file):
#   SHELL_FORMAT_PATH ?= .   # path passed to shfmt (walked recursively)
#   SHELL_LINT_PATH   ?= .   # path searched for *.sh files passed to shellcheck

SHELL_FORMAT_PATH ?= .
SHELL_LINT_PATH ?= .

.PHONY: install-shellcheck
install-shellcheck:
	@if ! command -v shellcheck >/dev/null 2>&1; then \
		echo "📦 shellcheck not found, installing..."; \
		case "$$(uname -s)" in \
			Darwin) brew install shellcheck ;; \
			*) sudo apt-get update && sudo apt-get install -y shellcheck ;; \
		esac; \
	fi

.PHONY: install-shfmt
install-shfmt:
	@if ! command -v shfmt >/dev/null 2>&1; then \
		echo "📦 shfmt not found, installing..."; \
		case "$$(uname -s)" in \
			Darwin) brew install shfmt ;; \
			*) go install mvdan.cc/sh/v3/cmd/shfmt@latest ;; \
		esac; \
	fi

.PHONY: lint-shell
lint-shell: install-shellcheck
	@echo "🐚 Running shellcheck on shell scripts..."
	find $(SHELL_LINT_PATH) -type f -name '*.sh' -print0 | xargs -0 -r shellcheck
	@echo "✅ Shellcheck passed"

.PHONY: format-shell
format-shell: install-shfmt
	@echo "🔧 Running shfmt to format shell scripts..."
	shfmt -l -w $(SHELL_FORMAT_PATH)
	@echo "✅ Shell formatting complete"

endif
