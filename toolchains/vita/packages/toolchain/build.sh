#! /bin/sh

VITA_VERSION=2.343
# This one must be updated as well
PKG_DATE=2022-05-27_09-56-28

PACKAGE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HELPERS_DIR=$PACKAGE_DIR/../..
. $HELPERS_DIR/functions.sh

do_make_bdir

do_http_fetch vitasdk "https://github.com/vitasdk/autobuilds/releases/download/master-linux-v$VITA_VERSION/vitasdk-x86_64-linux-gnu-$PKG_DATE.tar.bz2" 'tar xjf'

cp -a . $DESTDIR/$VITASDK

do_clean_bdir
