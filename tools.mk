ifndef TOOLS_MK_INCLUDED
TOOLS_MK_INCLUDED := 1

# Target that reports which command-line tools are installed.
#
# Every tool of `TOOLS` is looked up on the `PATH`; one aligned line per tool gives its version
# (first version number printed by `<tool> --version`, `?` if none) and where it was found, or says
# it is missing. All tools are listed so one run shows everything that is missing. The target fails
# with exit code 127 if a tool is missing.
#
# `check-tool-releases` is the online counterpart: it also shows when the installed version of each
# tool was released. The date is looked up over the network (GitHub releases, npm or PyPI, as given
# by `TOOL_SOURCES`), so it is slower and needs `curl`; `check-tools` stays instant and offline. A
# date that cannot be found (no source, offline, rate-limited) is shown as `?` and never fails the
# target; only a missing tool does (exit code 127). Set `GITHUB_TOKEN` to raise the GitHub rate limit.
#
# Optional variables (set before including this file, or on the command line):
#   TOOLS ?= actionlint bats ...          # space-separated tools to check (default: tools used by this repo)
#   TOOL_SOURCES ?= actionlint=github:rhysd/actionlint ...
#                                         # space-separated `<tool>=<kind>:<id>` where kind is `github`
#                                         # (owner/repo), `npm` (package) or `pypi` (package)

TOOLS ?= actionlint bats checkmake gh markdownlint mbake prettier shellcheck shfmt taplo yamllint zizmor
TOOL_SOURCES ?= actionlint=github:rhysd/actionlint bats=github:bats-core/bats-core \
	checkmake=github:checkmake/checkmake gh=github:cli/cli markdownlint=npm:markdownlint-cli \
	mbake=pypi:mbake prettier=npm:prettier shellcheck=github:koalaman/shellcheck \
	shfmt=github:mvdan/sh taplo=github:tamasfe/taplo yamllint=pypi:yamllint \
	zizmor=github:zizmorcore/zizmor

.PHONY: check-tools
check-tools: ## Show which tools are installed and which are missing
	@echo "🧰 Checking the tools..."
	@missing=""; total=0; width=0; \
	for tool in $(TOOLS); do \
		if [ $${#tool} -gt $$width ]; then width=$${#tool}; fi; \
		done; \
	for tool in $(TOOLS); do \
		total=$$((total + 1)); \
		if path=$$(command -v "$$tool"); then \
			version=$$("$$tool" --version </dev/null 2>&1 | grep -o -E '[0-9]+(\.[0-9]+)+' | head -n 1 || true); \
			printf '✅ %-*s  %-9s %s\n' "$$width" "$$tool" "$${version:-?}" "$$path"; \
		else \
			printf '❌ %-*s  not found\n' "$$width" "$$tool"; \
			missing="$$missing $$tool"; \
		fi; \
	done; \
	if [ -n "$$missing" ]; then \
		echo "⚠️ Missing:$$missing"; \
		exit 127; \
	fi; \
	echo "✅ All the $$total tools are available"

.PHONY: check-tool-releases
check-tool-releases: ## Show the installed tool versions and when they were released (needs network)
	@echo "🧰 Checking the tools and their release dates (network needed)..."
	@missing=""; total=0; width=0; \
	auth=""; if [ -n "$${GITHUB_TOKEN:-}" ]; then auth="Authorization: Bearer $$GITHUB_TOKEN"; fi; \
	for tool in $(TOOLS); do \
		if [ $${#tool} -gt $$width ]; then width=$${#tool}; fi; \
		done; \
	for tool in $(TOOLS); do \
		total=$$((total + 1)); \
		if path=$$(command -v "$$tool"); then \
			version=$$("$$tool" --version </dev/null 2>&1 | grep -o -E '[0-9]+(\.[0-9]+)+' | head -n 1 || true); \
			date=""; source=""; \
			for entry in $(TOOL_SOURCES); do \
				if [ "$${entry%%=*}" = "$$tool" ]; then source="$${entry#*=}"; fi; \
				done; \
			if [ -n "$$version" ] && [ -n "$$source" ]; then \
				id="$${source#*:}"; \
				case "$${source%%:*}" in \
					github) \
					for tag in "v$$version" "$$version"; do \
						date=$$(curl -fsSL --max-time 10 -H "Accept: application/vnd.github+json" \
						$${auth:+-H "$$auth"} "https://api.github.com/repos/$$id/releases/tags/$$tag" 2>/dev/null \
						| grep -o -E '"published_at": *"[^"]+"' | head -n 1 | cut -d'"' -f4 | cut -c1-10 || true); \
						if [ -n "$$date" ]; then break; fi; \
						done ;; \
					npm) \
						date=$$(curl -fsSL --max-time 20 "https://registry.npmjs.org/$$id" 2>/dev/null \
							| grep -o -E "\"$$version\": *\"[0-9T:.Z-]+\"" | head -n 1 | cut -d'"' -f4 | cut -c1-10 || true) ;; \
					pypi) \
						date=$$(curl -fsSL --max-time 10 "https://pypi.org/pypi/$$id/$$version/json" 2>/dev/null \
							| grep -o -E '"upload_time_iso_8601": *"[^"]+"' | head -n 1 | cut -d'"' -f4 | cut -c1-10 || true) ;; \
				esac; \
			fi; \
			printf '✅ %-*s  %-9s %-10s  %s\n' "$$width" "$$tool" "$${version:-?}" "$${date:-?}" "$$path"; \
		else \
			printf '❌ %-*s  not found\n' "$$width" "$$tool"; \
			missing="$$missing $$tool"; \
		fi; \
	done; \
	if [ -n "$$missing" ]; then \
		echo "⚠️ Missing:$$missing"; \
		exit 127; \
	fi; \
	echo "✅ All the $$total tools are available"

endif
