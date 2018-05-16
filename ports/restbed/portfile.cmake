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

IF(${CMAKE_HOST_SYSTEM_NAME} MATCHES "Windows")
message(STATUS "Configuring CMAKE for Windows Builds")
  vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}
        PREFER_NINJA
        CURRENT_PACKAGES_DIR ${CURRENT_PACKAGES_DIR}
        OPTIONS
	  -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=1
          -DBUILD_TESTS=NO
          -DBUILD_EXAMPLES=NO
          -DBUILD_SSL=NO
	  -DBUILD_SHARED=YES
  )
  vcpkg_install_cmake()
  vcpkg_copy_pdbs()
  message(STATUS "COPYING WINDOWS DLLs")
  file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/restbed.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin/ )
  file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/restbed.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin/ )
  file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/restbed.pdb DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin/ )
  file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/restbed.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin/ )
  file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/restbed.lib DESTINATION ${CURRENT_PACKAGES_DIR}/bin/ )
  file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/restbed.pdb DESTINATION ${CURRENT_PACKAGES_DIR}/bin/ )

  # The next 3 lines shouldn't be necessary, but the build isn't putting the files there
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib)
  SET(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)
ELSE()
  message(STATUS "Configuring CMAKE for Linux Builds")
  vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}
        PREFER_NINJA
        CURRENT_PACKAGES_DIR ${CURRENT_PACKAGES_DIR}
        OPTIONS
          -DBUILD_TESTS=NO
          -DBUILD_EXAMPLES=NO
          -DBUILD_SSL=YES
          -DBUILD_SHARED=YES
          -DCMAKE_CXX_STANDARD_LIBRARIES="-ldl"
  )
  vcpkg_install_cmake()
ENDIF(${CMAKE_HOST_SYSTEM_NAME} MATCHES "Windows")

message(STATUS "COPYING SOURCE")
file(INSTALL ${SOURCE_PATH}/source/corvusoft DESTINATION ${CURRENT_PACKAGES_DIR}/include/ )
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/restbed/ )
file(COPY ${CURRENT_PACKAGES_DIR}/share/restbed/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/restbed/copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)


message(STATUS "FINISHED")
