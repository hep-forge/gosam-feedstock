#! /usr/bin/bash
set -eux

# quadninja (a quadruple-precision variant of the vendored Ninja
# reduction library, an optional add-on -- meson_options.txt default
# true) needs libquadmath, which GCC only ever builds for x86/x86_64:
# aarch64's `long double` is already native IEEE-754 binary128 in
# hardware, so there's no separate quad-precision emulation library to
# link against there at all. Disable off-x86_64.
QUADNINJA=true
case "$(uname -m)" in
  x86_64) ;;
  *) QUADNINJA=false ;;
esac

meson setup builddir \
  --prefix="${PREFIX}" \
  --buildtype=release \
  -Dquadninja=${QUADNINJA}

# Ninja's tarball has a plain-text file called `version` at its top, which
# meson puts on the include path. On macOS's case-insensitive filesystem it
# then stands in for libc++'s <version> header and nothing compiles. The
# build (subprojects/packagefiles/ninja/meson.build) never reads it.
if [[ "$(uname)" == "Darwin" ]]; then
  rm -f subprojects/ninja-*/version
fi

meson compile -C builddir

meson install -C builddir
