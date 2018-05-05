#header-only library
include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/GSL
    REF 5cbde3008aa43a9c5f6c219ee15b8388336d4433
    SHA512 b58a9f37357326be1a3f630e25dbb1e1df88147cd3a6cf81e175e3e1fdeeb8559823b7e6061cd2fa18414e6706b7357bd1a6bded840cfb620af142cc974b0d33
    HEAD_REF master
)

file(INSTALL ${SOURCE_PATH}/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/ms-gsl RENAME copyright)
