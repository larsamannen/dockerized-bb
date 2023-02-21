#! /bin/sh

PACKAGE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HELPERS_DIR=$PACKAGE_DIR/../..
. $HELPERS_DIR/functions.sh

do_make_bdir

do_pkg_fetch gettext

autoreconf -vfi

do_configure --disable-libasprintf --disable-java --disable-c++
# No binaries, no man, ...
do_make -C gettext-runtime/intl
do_make -C gettext-runtime/intl install

do_clean_bdir
