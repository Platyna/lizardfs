exec_program(dpkg ARGS --print-architecture OUTPUT_VARIABLE DPKG_ARCHITECTURE)
set(CPACK_GENERATOR TGZ DEB)
set(CPACK_SOURCE_GENERATOR TGZ)
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 1)
set(CPACK_PACKAGE_NAME lizardfs)
set(CPACK_PACKAGE_DESCRIPTION_FILE ${CMAKE_SOURCE_DIR}/README)
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "LizardFS is a distributed file system")
set(CPACK_PACKAGE_VENDOR "LizardFS.org")
set(CPACK_PACKAGE_CONTACT "contact@lizardfs.org")
set(CPACK_PACKAGE_VERSION_MAJOR ${PACKAGE_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PACKAGE_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_MICRO ${PACKAGE_VERSION_MICRO})
set(CPACK_PACKAGE_VERSION ${PACKAGE_VERSION})
SET(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}_${CPACK_PACKAGE_VERSION}_${DPKG_ARCHITECTURE}")
set(CPACK_PACKAGING_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Marcin Sulikowski <contact@lizardfs.org>")
set(CPACK_DEBIAN_PACKAGE_SECTION "admin")
set(CPACK_DEBIAN_PACKAGE_PRIORITY "extra")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE ${DPKG_ARCHITECTURE})
# TODO(sulik) Create all postinst, prerm, postrm ... scrips and make them work
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA ${POSTINST_SCRIPT})
message(STATUS "CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA=${POSTINST_SCRIPT}")
# TODO(sulik) This dependencies shold ge generated, not hardcoded
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6 (>= 2.14), libfuse2 (>= 2.8.1), libgcc1 (>= 1:4.1.1), libstdc++6 (>= 4.1.1)")
include(CPack)
