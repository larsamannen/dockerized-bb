#! /bin/sh

CCTOOLS_PORT_VERSION=d3628fc1bea8b0c7579e3a288590d043cc1638cb
export LDID_VERSION=4bf8f4d60384a0693dbbe2084ce62a35bfeb87ab

PACKAGE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HELPERS_DIR=$PACKAGE_DIR/../..
. $HELPERS_DIR/functions.sh

do_make_bdir

do_git_fetch cctools-port "https://github.com/larsamannen/cctools-port" "${CCTOOLS_PORT_VERSION}"

TARGETDIR="${TARGET_DIR}" \
TRIPLE=aarch64-apple-darwin11 \
	./usage_examples/tvos_toolchain/build.sh "${SDK_DIR}/"* arm64

# Create symlinks to arm64 as official Apple tools are named like this
for f in "${TARGET_DIR}"/bin/aarch64-apple-darwin11-*; do
	ln -s "$(basename "$f")" "$(echo "$f" | sed -e 's|/aarch64-|/arm64-|')"
done

# Install codesign shim
cp "${PACKAGE_DIR}"/codesign "${TARGET_DIR}"/bin

do_clean_bdir
