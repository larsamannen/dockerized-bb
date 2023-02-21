#! /bin/sh

PACKAGE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HELPERS_DIR=$PACKAGE_DIR/../..
. $HELPERS_DIR/functions.sh

do_make_bdir

do_pkg_fetch glib2.0
do_patch glib

# Only keep glib and gthread
sed -i -e "/subdir('/{/'glib'/n; /'gthread'/n; s/^/#/}" meson.build

do_meson "$@"
ninja
ninja install

do_clean_bdir
