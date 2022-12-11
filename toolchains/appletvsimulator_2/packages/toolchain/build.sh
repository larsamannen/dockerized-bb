#! /bin/sh

CCTOOLS_PORT_VERSION=11c93763d7e7ce7305163341d08052374e4712de
export LDID_VERSION=4bf8f4d60384a0693dbbe2084ce62a35bfeb87ab

PACKAGE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HELPERS_DIR=$PACKAGE_DIR/../..
. $HELPERS_DIR/functions.sh

do_make_bdir

do_git_fetch cctools-port "https://github.com/tpoechtrager/cctools-port.git" "${CCTOOLS_PORT_VERSION}"

TARGETDIR="${TARGET_DIR}" \
TRIPLE=aarch64-apple-darwin11 \
	./usage_examples/tvossimulator_toolchain/build.sh "${SDK_DIR}/"* x86_64

# Create symlinks to x86_64 as official Apple tools are named like this
for f in "${TARGET_DIR}"/bin/aarch64-apple-darwin11-*; do
	ln -s "$(basename "$f")" "$(echo "$f" | sed -e 's|/aarch64-|/x86_64-|')"
done

# Install codesign shim
cp "${PACKAGE_DIR}"/codesign "${TARGET_DIR}"/bin

do_clean_bdir
