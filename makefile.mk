ifndef MAKEFILE_MK_INCLUDED
MAKEFILE_MK_INCLUDED := 1

# Targets for formatting and linting Makefiles.
#
# Optional variables (set before including this file):
#   MAKEFILE_FORMAT_FILES ?= Makefile   # files passed to mbake format
#   MAKEFILE_LINT_FILES   ?= Makefile   # files passed to checkmake

MAKEFILE_FORMAT_FILES ?= Makefile
MAKEFILE_LINT_FILES ?= Makefile

# Directories tools may be installed into that are not always on PATH.
PYTHON_USER_BIN := $(shell python3 -m site --user-base 2>/dev/null)/bin
GO_BIN := $(shell go env GOPATH 2>/dev/null)/bin
ifeq (,$(findstring $(PYTHON_USER_BIN),$(PATH)))
export PATH := $(PATH):$(PYTHON_USER_BIN)
endif
ifeq (,$(findstring $(GO_BIN),$(PATH)))
export PATH := $(PATH):$(GO_BIN)
endif

.PHONY: install-mbake
install-mbake:
	@if ! command -v mbake >/dev/null 2>&1; then \
		echo "📦 mbake not found, installing..."; \
		if command -v pipx >/dev/null 2>&1; then \
			pipx install mbake; \
		else \
			pip3 install --user --break-system-packages mbake; \
		fi; \
	fi

.PHONY: install-checkmake
install-checkmake:
	@if ! command -v checkmake >/dev/null 2>&1; then \
		echo "📦 checkmake not found, installing..."; \
		go install github.com/mrtazz/checkmake/cmd/checkmake@latest; \
	fi

.PHONY: format-makefile
format-makefile: install-mbake
	@echo "✨ Running mbake to format Makefiles..."
	mbake format $(MAKEFILE_FORMAT_FILES)
	@echo "✅ Makefile formatting complete"

.PHONY: lint-makefile
lint-makefile: install-checkmake
	@echo "🔍 Running checkmake on Makefiles..."
	checkmake $(MAKEFILE_LINT_FILES)
	@echo "✅ Checkmake passed"

endif
