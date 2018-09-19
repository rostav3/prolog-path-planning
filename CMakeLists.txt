cmake_minimum_required(VERSION 3.12)
project(prolog-path-planning)

set(CMAKE_CXX_STANDARD 14)

set(SOURCES src/main.cpp)


# find SWI Prolog libraries
#find_package(PkgConfig)
#find_package(SWIPL REQUIRED)
#pkg_check_modules(SWIPL REQUIRED swipl)
#include_directories(/usr/local/bin/swipl)
#link_directories(/usr/local/bin/swipl)


# LINUX SPECIFIC
if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    target_link_libraries (uWS LINK_PUBLIC pthread)
    install (TARGETS uWS DESTINATION /usr/lib64)
    install (FILES src/Extensions.h src/WebSocketProtocol.h src/Networking.h src/WebSocket.h src/Hub.h src/Group.h src/Node.h src/Socket.h src/HTTPSocket.h src/uWS.h src/uUV.h DESTINATION /usr/include/uWS)
endif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")

# MACOS SPECIFIC
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

    include_directories(/usr/local/include)
    include_directories(/usr/local/opt/openssl/include)
    link_directories(/usr/local/lib)
    link_directories(/usr/local/opt/openssl/lib)
    link_directories(/usr/local/Cellar/libuv/1.11.0/lib)

endif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")


add_executable(path_planning ${SOURCES})

target_link_libraries(path_planning z ssl uv uWS)