include(vcpkg_common_functions)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    message("azure-uamqp-c only supports static linkage")
    set(VCPKG_LIBRARY_LINKAGE "static")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Azure/azure-uamqp-c
    REF 1.2.4
    SHA512 939ed78dba8efe76dda4009682cd1bc575444be50bb8fe46550cd819a4490447ebcd9a16f668911ba8642082a4f79e57bdc190536d167e50f0237368b0ed6575
    HEAD_REF master
)

vcpkg_apply_patches(SOURCE_PATH ${SOURCE_PATH} PATCHES ${CMAKE_CURRENT_LIST_DIR}/glob-headers.patch)

file(COPY ${CURRENT_INSTALLED_DIR}/share/azure-c-shared-utility/azure_iot_build_rules.cmake DESTINATION ${SOURCE_PATH}/deps/azure-c-shared-utility/configs/)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_AS_DYNAMIC)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -Dskip_samples=ON
        -Duse_installed_dependencies=ON
        -Dbuild_as_dynamic=${BUILD_AS_DYNAMIC}
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH cmake TARGET_PATH share/uamqp)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)

file(INSTALL
    ${SOURCE_PATH}/LICENSE
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/azure-uamqp-c RENAME copyright)

vcpkg_copy_pdbs()
