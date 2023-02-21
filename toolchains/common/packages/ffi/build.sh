#! /bin/sh

PACKAGE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HELPERS_DIR=$PACKAGE_DIR/../..
. $HELPERS_DIR/functions.sh

do_make_bdir

do_pkg_fetch libffi

do_configure --disable-builddir
do_make
# Install only includes and library (no man pages, nor info)
do_make -C include install
do_make install-pkgconfigDATA install-toolexeclibLTLIBRARIES

do_clean_bdir
