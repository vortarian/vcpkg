include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ocornut/imgui
    REF v1.60
    SHA512  405b79ced59b4e4e45eebdbf278435f325a553e04338702dbdd3f30c7a39cb52a4dad91443bd99d19f61e60cd78d544fc1436ae2d10fef7c3a8a46cbb62685d9
    HEAD_REF master
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS_DEBUG
        -DIMGUI_SKIP_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_cmake_targets(CONFIG_PATH share/imgui)

file(COPY ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/imgui)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/imgui/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/imgui/copyright)
