include(GNUInstallDirs)

string(FIND ${CMAKE_LIBRARY_ARCHITECTURE} "x86_64" MATCH_RESULT)
if(NOT ${MATCH_RESULT} MATCHES -1)
  set(Arena_PACKAGE_DIR         "ArenaSDK_Linux_x64")
  set(SUFFIX_ARENA_LIB_DIR      lib64)
  set(SUFFIX_GenICam_LIB_DIR    GenICam/library/lib/Linux64_x64)
  set(SUFFIX_ffmpeg_LIB_DIR     ffmpeg)
else()
  string(FIND ${CMAKE_LIBRARY_ARCHITECTURE} "aarch64" MATCH_RESULT)
    if(NOT ${MATCH_RESULT} MATCHES -1)
      set(Arena_PACKAGE_DIR         "ArenaSDK_Linux_ARM64")
      set(SUFFIX_ARENA_LIB_DIR      lib)
      set(SUFFIX_GenICam_LIB_DIR    GenICam/library/lib/Linux64_ARM)
      set(SUFFIX_ffmpeg_LIB_DIR     ffmpeg)
  else()
	    message(FATAL_ERROR "Unknown CPU Architecture: '" ${cpu_arc} "'")
    endif()
endif()

set(
  Arena_INSTALL_DIR_CANDIDATES
    ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}
    /usr/local/lib
    /usr/lib
)

set(FOUND_PACKAGE FALSE)
foreach(INSTALL_DIR IN LISTS Arena_INSTALL_DIR_CANDIDATES)
  if(NOT FOUND_PACKAGE AND EXISTS ${INSTALL_DIR}/${Arena_PACKAGE_DIR})
    message(STATUS "Package found at " ${INSTALL_DIR})
    set(Arena_INSTALL_DIR ${INSTALL_DIR})
    set(FOUND_PACKAGE TRUE)
  endif()
endforeach()
if(NOT FOUND_PACKAGE)
  message(FATAL_ERROR "Package not found")
endif()

#
# Arena
#

find_path(
  Arena_INCLUDE_DIR
    NAMES ArenaApi.h
    PATHS ${Arena_INSTALL_DIR}/${Arena_PACKAGE_DIR}
    PATH_SUFFIXES include/Arena
    NO_DEFAULT_PATH
)
find_library(
  Arena_LIBRARY
  NAMES arena
  PATHS ${Arena_INSTALL_DIR}/${Arena_PACKAGE_DIR}
  PATH_SUFFIXES ${SUFFIX_ARENA_LIB_DIR}
  NO_DEFAULT_PATH
)
if(Arena_INCLUDE_DIR AND Arena_LIBRARY)
  if(NOT Arena_FIND_QUIETLY)
    message(STATUS "Found components for Arena")
    message(STATUS "\t ${Arena_INCLUDE_DIR}")
    message(STATUS "\t ${Arena_LIBRARY}")
  endif()
else()
  if(Arena_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find Arena!")
  endif()
endif()

#
# Save
#

# find_path(
#   Save_INCLUDE_DIR
#     NAMES SaveApi.h
#     PATHS ${Arena_INSTALL_DIR}/${Arena_PACKAGE_DIR}
#     PATH_SUFFIXES include/Save
#     NO_DEFAULT_PATH
# )
# find_library(
#   Save_LIBRARY
#   NAMES save
#   PATHS ${Arena_INSTALL_DIR}/${Arena_PACKAGE_DIR}
#   PATH_SUFFIXES ${SUFFIX_ARENA_LIB_DIR}
#   NO_DEFAULT_PATH
# )
# if(Save_INCLUDE_DIR AND Save_LIBRARY)
#   if(NOT Save_FIND_QUIETLY)
#     message(STATUS "Found components for Save")
#     message(STATUS "\t ${Save_INCLUDE_DIR}")
#     message(STATUS "\t ${Save_LIBRARY}")
#   endif()
# else()
#   if(Save_FIND_REQUIRED)
#     message(FATAL_ERROR "Could not find Save!")
#   endif()
# endif()

#
# GenTL
#

find_path(
  GenTL_INCLUDE_DIR
    NAMES GenTL.h
    PATHS ${Arena_INSTALL_DIR}/${Arena_PACKAGE_DIR}
    PATH_SUFFIXES include/GenTL
    NO_DEFAULT_PATH
)
find_library(
  GenTL_LIBRARY
  NAMES gentl
  PATHS ${Arena_INSTALL_DIR}/${Arena_PACKAGE_DIR}
  PATH_SUFFIXES ${SUFFIX_ARENA_LIB_DIR}
  NO_DEFAULT_PATH
)
if(GenTL_INCLUDE_DIR AND GenTL_LIBRARY)
  if(NOT GenTL_FIND_QUIETLY)
    message(STATUS "Found components for GenTL")
    message(STATUS "\t ${GenTL_INCLUDE_DIR}")
    message(STATUS "\t ${GenTL_LIBRARY}")
  endif()
else()
  if(GenTL_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find GenTL!")
  endif()
endif()

#
# GenICam
#

find_path(
  GenICam_INCLUDE_DIR
    NAMES GenICam.h
    PATHS ${Arena_INSTALL_DIR}/${Arena_PACKAGE_DIR}
    PATH_SUFFIXES GenICam/library/CPP/include
    NO_DEFAULT_PATH
)
find_library(
  GenApi_gcc54_v3_3_LUCID_LIBRARY
  NAMES GenApi_gcc54_v3_3_LUCID
  PATHS ${Arena_INSTALL_DIR}/${Arena_PACKAGE_DIR}
  PATH_SUFFIXES ${SUFFIX_GenICam_LIB_DIR}
  NO_DEFAULT_PATH
)
find_library(
  GCBase_gcc54_v3_3_LUCID_LIBRARY
  NAMES GCBase_gcc54_v3_3_LUCID
  PATHS ${Arena_INSTALL_DIR}/${Arena_PACKAGE_DIR}
  PATH_SUFFIXES ${SUFFIX_GenICam_LIB_DIR}
  NO_DEFAULT_PATH
)
if(GenICam_INCLUDE_DIR AND GenApi_gcc54_v3_3_LUCID_LIBRARY AND GCBase_gcc54_v3_3_LUCID_LIBRARY)
  if(NOT GenICam_FIND_QUIETLY)
    message(STATUS "Found components for GenICam")
    message(STATUS "\t ${GenICam_INCLUDE_DIR}")
    message(STATUS "\t ${GenApi_gcc54_v3_3_LUCID_LIBRARY}")
    message(STATUS "\t ${GCBase_gcc54_v3_3_LUCID_LIBRARY}")
  endif()
else()
  if(GenICam_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find GenICam!")
  endif()
endif()

set(
  Arena_INCLUDE_DIRS
    ${Arena_INCLUDE_DIR}
    # ${Save_INCLUDE_DIR}
    ${GenTL_INCLUDE_DIR}
    ${GenICam_INCLUDE_DIR}
)

set(
  Arena_LIBRARIES
    ${Arena_LIBRARY}
    # ${Save_LIBRARY}
    ${GenTL_LIBRARY}
    ${GenApi_gcc54_v3_3_LUCID_LIBRARY}
    ${GCBase_gcc54_v3_3_LUCID_LIBRARY}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  Arena
		DEFAULT_MSG
      Arena_INCLUDE_DIRS
      Arena_LIBRARIES
)

if(NOT TARGET Arena::Arena_)
  add_library(
    Arena::Arena_
      UNKNOWN IMPORTED
  )
  set_target_properties(
    Arena::Arena_
      PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Arena_INCLUDE_DIR}"
        IMPORTED_LOCATION             "${Arena_LIBRARY}"
  )
endif()

# if(NOT TARGET Arena::Save_)
#   add_library(
#     Arena::Save_
#       UNKNOWN IMPORTED
#   )
#   set_target_properties(
#     Arena::Save_
#       PROPERTIES
#         INTERFACE_INCLUDE_DIRECTORIES "${Save_INCLUDE_DIR}"
#         IMPORTED_LOCATION             "${Save_LIBRARY}"
#   )
# endif()

if(NOT TARGET Arena::GenTL_)
  add_library(
    Arena::GenTL_
      UNKNOWN IMPORTED
  )
  set_target_properties(
    Arena::GenTL_
      PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${GenTL_INCLUDE_DIR}"
        IMPORTED_LOCATION             "${GenTL_LIBRARY}"
  )
endif()

if(NOT TARGET Arena::GenICam_)
  add_library(
    Arena::GenICam_
      UNKNOWN IMPORTED
  )
  set_target_properties(
    Arena::GenICam_
      PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${GenICam_INCLUDE_DIR}"
        IMPORTED_LOCATION             "${GenApi_gcc54_v3_3_LUCID_LIBRARY}"
        IMPORTED_LOCATION             "${GCBase_gcc54_v3_3_LUCID_LIBRARY}"
  )
endif()

if(NOT TARGET Arena::Arena)
	add_library(
		Arena::Arena
			INTERFACE IMPORTED
	)
	set_property(
		TARGET Arena::Arena
		PROPERTY
  			INTERFACE_LINK_LIBRARIES
          Arena::Arena_
          # Arena::Save_
          Arena::GenTL_
          Arena::GenICam_
	)
endif()

mark_as_advanced(
	Arena_INCLUDE_DIRS
	Arena_LIBRARIES
)
