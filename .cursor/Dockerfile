# Cloud Agent base image for Gaphor.
#
# Gaphor 3.x targets the GNOME 49 stack (libadwaita >= 1.8, GTK 4). Ubuntu 25.10
# ("questing") ships libadwaita 1.8, GTK 4.20, GtkSourceView 5 and Python 3.13,
# which satisfy pyproject.toml's requirements (Python >=3.12,<3.15).
FROM ubuntu:25.10

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/usr/local/bin \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# System dependencies:
#   - build toolchain + headers to compile PyGObject and pycairo,
#   - the GTK 4 / libadwaita / GtkSourceView runtime and introspection data,
#   - graphviz for the auto-layout feature,
#   - xvfb/mutter/dbus for running the GTK UI, self-test and tests headlessly,
#   - pipx to install poetry and pre-commit.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        locales \
        build-essential \
        pkg-config \
        python3 \
        python3-dev \
        python3-venv \
        python3-pip \
        pipx \
        libcairo2-dev \
        libglib2.0-dev \
        libgirepository-2.0-dev \
        gir1.2-gtk-4.0 \
        libgtksourceview-5-dev \
        libadwaita-1-dev \
        gsettings-desktop-schemas \
        adwaita-icon-theme \
        librsvg2-common \
        graphviz \
        fonts-dejavu \
        dbus-x11 \
        mutter \
        xauth \
        xvfb \
    && rm -rf /var/lib/apt/lists/*

# Poetry (>=2.0 is required by pyproject.toml) and pre-commit, installed globally
# via pipx so they are on PATH for every user. pre-commit is installed this way
# because CI runs linting through `pipx run pre-commit` rather than the project venv.
RUN pipx install poetry \
    && pipx install pre-commit

# The official Ubuntu image already provides a non-root "ubuntu" user (uid 1000);
# create it defensively in case that ever changes.
RUN id ubuntu >/dev/null 2>&1 || useradd --create-home --shell /bin/bash --uid 1000 ubuntu

USER ubuntu
