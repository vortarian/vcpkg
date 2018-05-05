include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Exiv2/exiv2
    REF f86542e5f692e98f10b44c43c6f5d2cec833dddd
    SHA512 d1e049af22664c5b54ec83c44f6f20b7a154f628d764c3b24b2fb806edba0c7beb5824c98fbe7514a9394e55578254f1793e7c2018b10c7627ef691f1c1c6bbf
    HEAD_REF master
)

vcpkg_apply_patches(
    SOURCE_PATH "${SOURCE_PATH}"
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/use-iconv.patch"
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH "share/exiv2/cmake")

vcpkg_copy_pdbs()

# Clean
file(GLOB EXE ${CURRENT_PACKAGES_DIR}/bin/*.exe ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share ${EXE} ${DEBUG_EXE})

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

# Handle copyright 
file(COPY ${SOURCE_PATH}/ABOUT-NLS DESTINATION ${CURRENT_PACKAGES_DIR}/share/exiv2)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/exiv2/ABOUT-NLS ${CURRENT_PACKAGES_DIR}/share/exiv2/copyright)
