ifndef MAKEFILE_MK_INCLUDED
MAKEFILE_MK_INCLUDED := 1

# Targets for formatting and linting Makefiles.
#
# Optional variables (set before including this file):
#   MAKEFILE_FORMAT_FILES ?= Makefile   # files passed to mbake format
#   MAKEFILE_LINT_FILES   ?= Makefile   # files passed to checkmake

MAKEFILE_FORMAT_FILES ?= Makefile
MAKEFILE_LINT_FILES ?= Makefile

# Extra dirs tools may install into that aren't always on PATH.
# Resolved at recipe run time (not parse time) since the tool may have just
# been installed by the target's own prerequisite.
EXTRA_BIN_PATH = $(HOME)/.local/bin:$(shell command -v pipx >/dev/null 2>&1 && pipx environment --value PIPX_BIN_DIR 2>/dev/null):$(shell go env GOPATH 2>/dev/null)/bin

# mbake has no Homebrew formula, so macOS also goes through pipx/pip.
.PHONY: install-mbake
install-mbake:
	@if ! command -v mbake >/dev/null 2>&1; then \
		echo "📦 mbake not found, installing..."; \
		if command -v pipx >/dev/null 2>&1; then \
			pipx install mbake; \
		elif [ "$$(uname -s)" = "Darwin" ]; then \
			brew install pipx && pipx install mbake; \
		else \
			pip3 install --user --break-system-packages mbake; \
		fi; \
	fi

.PHONY: install-checkmake
install-checkmake:
	@if ! command -v checkmake >/dev/null 2>&1; then \
		echo "📦 checkmake not found, installing..."; \
		case "$$(uname -s)" in \
			Darwin) brew install checkmake ;; \
			*) go install github.com/mrtazz/checkmake/cmd/checkmake@latest ;; \
		esac; \
	fi

.PHONY: format-makefile
format-makefile: install-mbake
	@echo "✨ Running mbake to format Makefiles..."
	PATH="$(EXTRA_BIN_PATH):$$PATH" mbake format $(MAKEFILE_FORMAT_FILES)
	@echo "✅ Makefile formatting complete"

.PHONY: lint-makefile
lint-makefile: install-checkmake
	@echo "🔍 Running checkmake on Makefiles..."
	PATH="$(EXTRA_BIN_PATH):$$PATH" checkmake $(MAKEFILE_LINT_FILES)
	@echo "✅ Checkmake passed"

endif
