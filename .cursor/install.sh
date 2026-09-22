#!/usr/bin/env bash
#
# Idempotent bootstrap for the Gaphor Cloud Agent environment. Runs from the
# repository root after the source tree is checked out.
set -euo pipefail

# Install runtime plus test/dev dependencies into an in-project .venv.
#
# The "lint" group is intentionally skipped: poetry.lock pins
# virtualenv==20.37.0, which has been yanked from PyPI, so installing that group
# fails. Linting is run via `pipx run pre-commit run --all-files` (the same way
# the project's CI runs it), which does not need the poetry-managed virtualenv.
poetry install --no-interaction --without lint

# Compile the GSettings schemas the GTK UI needs to store its settings.
poetry run gaphor install-schemas

# Compile all translation catalogs (.po -> .mo).
poetry run poe gettext-mo-all
