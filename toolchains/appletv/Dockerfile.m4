m4_dnl These settings must be kept in sync between toolchain and worker
m4_define(`PPA_CLANG',-14)m4_dnl
m4_define(`XOS_SDK_VERSION',16.1)m4_dnl
m4_define(`XOS_DEPLOYMENT_TARGET',9.0)m4_dnl

m4_define(`XOS_SDK_BASE',AppleTVOS)m4_dnl
m4_define(`XOS_PLATFORM',tv)m4_dnl

m4_define(`XOS_BITCODE_FLAG',)m4_dnl
m4_define(`XOS_C_LD_FLAGS',)m4_dnl
m4_define(`XOS_C_CPP_LD_FLAGS',)m4_dnl
m4_define(`XOS_MESON_FLAGS',)m4_dnl

m4_include(`apple/xos.m4')m4_dnl
