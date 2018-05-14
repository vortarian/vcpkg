include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ArashPartow/strtk
    REF 48c9554b3f079e34205c0af661c81c6f75f1da05
    SHA512 92a1b34808f20489d9b8c94aed384b08fcf2586967185c23a0027ee6d7170d5998e255d6aedc1fbb68327f48c0b106b8efd39f476e4041d6bcc5685c73fc1015
)

file(COPY ${SOURCE_PATH}/strtk.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/copyright DESTINATION ${CURRENT_PACKAGES_DIR}/share/strtk)
