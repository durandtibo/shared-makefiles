ifndef MAKEFILE_MK_INCLUDED
MAKEFILE_MK_INCLUDED := 1

# Targets for formatting and linting Makefiles.
#
# Optional variables (set before including this file):
#   MAKEFILE_FORMAT_FILES ?= Makefile   # files passed to mbake format
#   MAKEFILE_LINT_FILES   ?= Makefile   # files passed to checkmake

MAKEFILE_FORMAT_FILES ?= Makefile
MAKEFILE_LINT_FILES ?= Makefile

.PHONY: format-makefile
format-makefile:
	@echo "✨ Running mbake to format Makefiles..."
	mbake format $(MAKEFILE_FORMAT_FILES)
	@echo "✅ Makefile formatting complete"

.PHONY: lint-makefile
lint-makefile:
	@echo "🔍 Running checkmake on Makefiles..."
	checkmake $(MAKEFILE_LINT_FILES)
	@echo "✅ Checkmake passed"

endif
