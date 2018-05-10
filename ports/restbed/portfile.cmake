include(vcpkg_common_functions)

set(RESTBED_VERSION 4.6)

set(GIT_URL "git://github.com/corvusoft/restbed.git")
set(GIT_REF "${RESTBED_VERSION}") # Commit

# Prepare source dir
if(NOT EXISTS "${DOWNLOADS}/restbed.git")
    message(STATUS "Cloning")
    vcpkg_execute_required_process(
        COMMAND ${GIT} clone --bare --branch ${GIT_REF} ${GIT_URL} ${DOWNLOADS}/restbed.git
        WORKING_DIRECTORY ${DOWNLOADS}
        LOGNAME clone
    )
endif()
message(STATUS "Cloning done")

if(NOT EXISTS "${CURRENT_BUILDTREES_DIR}/src/.git")
    message(STATUS "Adding worktree")
    file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR})
    vcpkg_execute_required_process(
        COMMAND ${GIT} worktree add -f --detach ${CURRENT_BUILDTREES_DIR}/src ${GIT_REF}
        WORKING_DIRECTORY ${DOWNLOADS}/restbed.git
        LOGNAME worktree
    )
    vcpkg_execute_required_process(
        COMMAND ${GIT} submodule update --init --recursive
        WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/src
        LOGNAME worktree
    )
endif()
message(STATUS "Adding worktree done")

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/)

#set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/restbed-${RESTBED_VERSION})
#vcpkg_download_distfile(ARCHIVE_FILE
    #URLS "https://github.com/Corvusoft/restbed/archive/${RESTBED_VERSION}.tar.gz"
    #FILENAME "restbed-${RESTBED_VERSION}.tar.gz"
    #SHA512 81fbc7c90b6690ba9926c7990495bf114d4b4511785cf8ad7d526a119104e6eea0d0945c7e73e94ff7005b996b96ec4ecb067e192da04afa20e854c1f982549d
#)
#vcpkg_extract_source_archive(${ARCHIVE_FILE})


message(STATUS "Configuring CMAKE")
vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}
        PREFER_NINJA
        CURRENT_PACKAGES_DIR ${CURRENT_PACKAGES_DIR}
        OPTIONS
	    -DBUILD_TESTS=NO
	    -DBUILD_EXAMPLES=NO
            -DBUILD_SSL=YES
            -DBUILD_SHARED=NO
            -DCMAKE_CXX_STANDARD_LIBRARIES="-ldl"
)

message(STATUS "CMAKE INSTALL")
vcpkg_install_cmake()
# vcpkg_fixup_cmake_targets()


message(STATUS "COPYING SOURCE")
file(INSTALL ${SOURCE_PATH}/source/corvusoft DESTINATION ${CURRENT_PACKAGES_DIR}/include/ )
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/restbed/ )
file(COPY ${CURRENT_PACKAGES_DIR}/share/restbed/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/restbed/copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)


message(STATUS "FINISHED")
