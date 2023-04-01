cmake_minimum_required(VERSION 3.21)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
	message(FATAL_ERROR "Do not build in-source. Please remove CMakeCache.txt and the CMakeFiles/ directory. Then build out-of-source.")
endif()

set(CMAKE_CXX_STANDARD			20)
set(CMAKE_CXX_STANDARD_REQUIRED	True)

project(
	arena_sdk
		VERSION		0.0.1
		LANGUAGES	CXX
)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

include(GNUInstallDirs)

########################
# download and prepare #
########################

# gdown
execute_process(COMMAND pip install gdown)

# [x86_64] architecture
if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")
	set(FILE_NAME "ArenaSDK_v0.1.68_Linux_x64.tar.gz")
	if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/build/${FILE_NAME})
		set(URL "https://drive.google.com/u/0/uc?id=1THUHFFYzzYwXf0BgiNH3L8ssVK-oClbI&export=download")
		execute_process(
			COMMAND python3 ${CMAKE_CURRENT_SOURCE_DIR}/scripts/__gdown.py ${URL}
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
	endif()
	if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/build/ArenaSDK_Linux_x64)
		execute_process(
			COMMAND tar -xzf ${FILE_NAME}
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
	endif()
	if(NOT EXISTS ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/ArenaSDK.conf)
		execute_process(
			COMMAND sh -c "echo ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/ArenaSDK_Linux_x64/lib64 > ArenaSDK.conf"
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
		execute_process(
			COMMAND sh -c "echo ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/ArenaSDK_Linux_x64/GenICam/library/lib/Linux64_x64 >> ArenaSDK.conf"
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
		execute_process(
			COMMAND sh -c "echo ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/ArenaSDK_Linux_x64/ffmpeg >> ArenaSDK.conf"
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
	endif()

# [arm64] architecture
elseif(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "aarch64")
	set(FILE_NAME "ArenaSDK_v0.1.49_Linux_ARM64.tar.gz")
	if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/build/${FILE_NAME})
		set(URL "https://drive.google.com/u/0/uc?id=1d02Q7vCVbi37GpY3IFu0BKP3IcGFYGlB&export=download")
		execute_process(
			COMMAND python3 ${CMAKE_CURRENT_SOURCE_DIR}/scripts/__gdown.py ${URL}
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
	endif()
	if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/build/ArenaSDK_Linux_ARM64)
		execute_process(
			COMMAND tar -xzf ${FILE_NAME}
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
	endif()
	if(NOT EXISTS ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/ArenaSDK.conf)
		execute_process(
			COMMAND sh -c "echo ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/ArenaSDK_Linux_ARM64/lib > ArenaSDK.conf"
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
		execute_process(
			COMMAND sh -c "echo ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/ArenaSDK_Linux_ARM64/GenICam/library/lib/Linux64_ARM >> ArenaSDK.conf"
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
		execute_process(
			COMMAND sh -c "echo ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/ArenaSDK_Linux_ARM64/ffmpeg >> ArenaSDK.conf"
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build)
	endif()

# [the other] architectures
else()
	message(${CMAKE_SYSTEM_PROCESSOR} " architecture is not supported yet")
endif()

###########
# install #
###########

if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")
	install(
		DIRECTORY 	${CMAKE_CURRENT_SOURCE_DIR}/build/ArenaSDK_Linux_x64
		DESTINATION ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}
	)
elseif(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "aarch64")
	install(
		DIRECTORY 	${CMAKE_CURRENT_SOURCE_DIR}/build/ArenaSDK_Linux_ARM64
		DESTINATION ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}
	)
endif()

install(
    FILES
		${CMAKE_CURRENT_SOURCE_DIR}/build/ArenaSDK.conf
    DESTINATION
		/etc/ld.so.conf.d
)
