#! /usr/bin/bash
set -eux

meson setup builddir \
  --prefix="${PREFIX}" \
  --buildtype=release

meson compile -C builddir

meson install -C builddir
