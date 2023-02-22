#! /bin/sh

FLUIDSYNTH_VERSION=2.3.1

PACKAGE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HELPERS_DIR=$PACKAGE_DIR/../..
. $HELPERS_DIR/functions.sh

do_make_bdir

# Debian version is quite old
do_http_fetch fluidsynth \
	"https://github.com/FluidSynth/fluidsynth/archive/v${FLUIDSYNTH_VERSION}.tar.gz" 'tar xzf'

# Fluidsynth doesn't link correctly against static glib, fix this
sed -i -e 's/\${GLIB_\([^}]\+\)}/${GLIB_STATIC_\1}/g' CMakeLists.txt src/CMakeLists.txt
sed -i -e '/add_executable ( fluidsynth/,/)/{
/)/a target_link_options ( fluidsynth PRIVATE ${GLIB_STATIC_LDFLAGS_OTHER} )
}' src/CMakeLists.txt
# Don't install fluidsynth binary
# Still build it to ensure we have a working setup with all static libraries
sed -i -e 's/install\(.*\) fluidsynth /install\1 /g' src/CMakeLists.txt

# -DCMAKE_SYSTEM_NAME=Windows for Windows

# Lighten Fluidsynth the most we can
do_cmake \
	-Denable-aufile=off -Denable-dbus=off \
	-Denable-network=off -Denable-jack=off \
	-Denable-ladspa=off -Denable-libinstpatch=off \
	-Denable-libsndfile=off -Denable-midishare=off \
	-Denable-opensles=off -Denable-oboe=off \
	-Denable-oss=off -Denable-dsound=off \
	-Denable-waveout=off -Denable-winmidi=off \
	-Denable-sdl2=off -Denable-pulseaudio=off \
	-Denable-readline=off -Denable-lash=off \
	-Denable-alsa=off -Denable-systemd=off \
	-Denable-coreaudio=off -Denable-coremidi=off \
	-Denable-framework=off -Denable-dart=off "$@"
do_make
do_make install

do_clean_bdir
