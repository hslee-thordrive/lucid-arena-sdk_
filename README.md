# HOW TO USE ARENA-SDK

## 1. INSTALL ARENA-SDK
```
$ git clone https://dev.azure.com/thordrive/revolt/_git/arena-sdk /tmp/arena
$ mkdir -p /tmp/arena/build
$ cd /tmp/arena/build
$ cmake ..
$ sudo make install
$ sudo ldconfig
$ rm -rf /tmp/arena
```

## 2. COPY FINDARENA.CMAKE TO YOUR PROJECT REPOSITORY
```
$ cp "${CMAKE_CURRENT_LIST_DIR}/cmake/FindArena.cmake {your_project_cmake_folder}
```

## 3. IMPORT ARENA-SDK on CMakeLists.txt
```
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

if(NOT TARGET Arena::Arena)
	find_package(Arena REQUIRED)
endif()

target_link_libraries(
	${PROJECT_NAME}
		Arena::Arena
)
```
