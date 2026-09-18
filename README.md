# shared-makefiles

Shared/reusable Makefiles for formatting and linting common file types across projects.

Each file is self-contained, include-guarded, and configurable via variables — pull in only what
you need.

## Usage

Include the files you need in your project's `Makefile`:

```makefile
include yaml.mk
include makefile.mk

.PHONY: format
format: format-yaml format-makefile

.PHONY: lint
lint: lint-yaml lint-makefile
```

Required tools (`prettier`, `yamllint`, `mbake`, `checkmake`) are installed on demand — each
`format-*`/`lint-*` target depends on an `install-*` target that installs the tool if it isn't
already on `PATH`.

## Available files

| File          | Targets                            | Tools                  | Description                |
| ------------- | ---------------------------------- | ---------------------- | -------------------------- |
| `yaml.mk`     | `format-yaml`, `lint-yaml`         | `prettier`, `yamllint` | Format and lint YAML files |
| `makefile.mk` | `format-makefile`, `lint-makefile` | `mbake`, `checkmake`   | Format and lint Makefiles  |

### `yaml.mk`

Optional variables (set before `include`):

| Variable           | Default | Description               |
| ------------------ | ------- | ------------------------- |
| `YAML_FORMAT_PATH` | `.`     | Path passed to `prettier` |
| `YAML_LINT_PATH`   | `.`     | Path passed to `yamllint` |

```makefile
include yaml.mk

YAML_LINT_PATH = .github/workflows
```

### `makefile.mk`

Optional variables (set before `include`):

| Variable                | Default    | Description                    |
| ----------------------- | ---------- | ------------------------------ |
| `MAKEFILE_FORMAT_FILES` | `Makefile` | Files passed to `mbake format` |
| `MAKEFILE_LINT_FILES`   | `Makefile` | Files passed to `checkmake`    |

```makefile
include makefile.mk

MAKEFILE_LINT_FILES = Makefile makefile.mk yaml.mk
```

## Design

- **Include guards** — each file defines an `_MK_INCLUDED` variable so it's safe to `include`
  more than once (e.g. transitively from multiple project Makefiles).
- **On-demand install** — every lint/format target depends on an `install-<tool>` target that
  checks `command -v` before installing, so CI and local runs don't need the tool preinstalled.
- **Configurable paths** — variables default to sensible project-wide values but can be
  overridden per project or per target invocation.

## Testing

[`.github/workflows/test.yml`](.github/workflows/test.yml) exercises every file against
`ubuntu-latest`, `macos-latest`, and `ubuntu-slim` on every push/PR to `main`, running both the
lint and format targets (including on-demand tool installation) to make sure the rules stay
portable across platforms.

## License

[MIT](LICENSE)
