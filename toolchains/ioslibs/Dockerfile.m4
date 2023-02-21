m4_dnl These settings must be kept in sync between toolchain and worker
# Use clang 9 since older Xcode versions doesn't support the bitcode
# format produced by the newer clang versions. Fetch it from Debian
m4_define(`DEBIAN_CLANG',-9)m4_dnl
m4_define(`XOS_SDK_VERSION',11.4)m4_dnl
m4_define(`XOS_DEPLOYMENT_TARGET',8.0)m4_dnl

m4_define(`XOS_SDK_BASE',iPhoneOS)m4_dnl
m4_define(`XOS_PLATFORM',iphone)m4_dnl

m4_define(`XOS_BITCODE_FLAG',-fembed-bitcode)m4_dnl
m4_define(`XOS_C_LD_FLAGS',CFLAGS="$CFLAGS XOS_BITCODE_FLAG -arch armv7 -arch armv7s -arch arm64" LDFLAGS="$LDFLAGS XOS_BITCODE_FLAG -arch armv7 -arch armv7s -arch arm64")m4_dnl
m4_define(`XOS_C_CPP_LD_FLAGS',XOS_C_LD_FLAGS CPPFLAGS="$CPPFLAGS XOS_BITCODE_FLAG -arch armv7 -arch armv7s -arch arm64")m4_dnl
m4_define(`XOS_MESON_FLAGS',-Db_bitcode=true)m4_dnl

m4_include(`apple/xos.m4')m4_dnl

# Now curl and glib doesn't really handle multi arch builds.
# So we have to generate a lib for each arch and use libtool to make a fat archive

# Copy the curl arm64 build
RUN mkdir ${PREFIX}/tmp && mv ${PREFIX}/lib/libcurl.a ${PREFIX}/tmp
# Generate lib for armv7 and armv7s
helpers_package(curl, --without-ssl --with-secure-transport --disable-ntlm-wb, CFLAGS="$CFLAGS -m`'XOS_PLATFORM`'os-version-min=XOS_DEPLOYMENT_TARGET XOS_BITCODE_FLAG -arch armv7 -arch armv7s" LDFLAGS="$LDFLAGS XOS_BITCODE_FLAG -arch armv7 -arch armv7s")
RUN mkdir ${PREFIX}/tmp2 && mv ${PREFIX}/lib/libcurl.a ${PREFIX}/tmp2/
RUN /opt/toolchain/bin/aarch64-apple-darwin11-libtool -static -o ${PREFIX}/lib/libcurl.a ${PREFIX}/tmp/libcurl.a ${PREFIX}/tmp2/libcurl.a
RUN rm -rf ${PREFIX}/tmp && rm -rf ${PREFIX}/tmp2

# Now rerun glib
RUN mkdir ${PREFIX}/tmp && mv ${PREFIX}/lib/libglib-2.0.a ${PREFIX}/tmp/
helpers_package(glib2.0, -Db_bitcode=true -Dc_args="-arch armv7" -Dc_link_args="-arch armv7")
RUN mkdir ${PREFIX}/tmp2 && mv ${PREFIX}/lib/libglib-2.0.a ${PREFIX}/tmp2/
helpers_package(glib2.0, -Db_bitcode=true -Dc_args="-arch armv7s" -Dc_link_args="-arch armv7s")
RUN mkdir ${PREFIX}/tmp3 && mv ${PREFIX}/lib/libglib-2.0.a ${PREFIX}/tmp3/
RUN /opt/toolchain/bin/aarch64-apple-darwin11-libtool -static -o ${PREFIX}/lib/libglib-2.0.a ${PREFIX}/tmp/libglib-2.0.a ${PREFIX}/tmp2/libglib-2.0.a ${PREFIX}/tmp3/libglib-2.0.a
RUN rm -rf ${PREFIX}/tmp && rm -rf ${PREFIX}/tmp2 && rm -rf ${PREFIX}/tmp3

# Build fluidsynth again and make a fat archive
helpers_package(fluidsynth, -DCMAKE_TOOLCHAIN_FILE=${TARGET_DIR}/XOS_PLATFORM`'.platform -DLIB_SUFFIX=)
