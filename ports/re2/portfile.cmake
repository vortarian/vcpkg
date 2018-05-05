include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/re2
    REF eb69e9172ec4015fa4ba74ac7b026f818abf8cf1
    SHA512 4ece6f65886b48b313b8fcaa2441324ebbc619c74f9c4eb2860639c9d458caa096538575e6ae6091f5a34d341ee8b1e36caba200f3bc9f276ea05cc9ef5d3891
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS -DRE2_BUILD_TESTING=OFF
)

vcpkg_install_cmake()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/re2 RENAME copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
