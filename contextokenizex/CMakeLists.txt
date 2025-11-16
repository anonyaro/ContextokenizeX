cmake_minimum_required(VERSION 3.10)

if(POLICY CMP0141)
    cmake_policy(SET CMP0141 NEW)
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS 1 CACHE INTERNAL "Suppress dev warnings")

project(ContextokenizeX LANGUAGES CXX)

set(SOURCE_FILES main.cpp updater/updater.cpp filedlg/readfile.cpp core/core.cpp core/qcorebridge.cpp)


set(SOURCE_OUT main.cpp)
set(OUTDIR ${CMAKE_SOURCE_DIR}/out/)


set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(UI ui/window.qml)


if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    message(STATUS "Compiler detected: ${CMAKE_CXX_COMPILER_ID}")
    add_compile_options(-std=c++2a -Wall -Wextra -Wpedantic)
endif()

if(MSVC)
    message(STATUS "Compiler detected: MSVC")
    add_compile_options(/permissive- /Zc:__cplusplus)
endif()

if(WIN32)
    message(STATUS "Detected OS: Windows")
elseif(UNIX AND NOT APPLE)
    message(STATUS "Detected OS: Linux")
else()
    message(FATAL_ERROR "Unsupported platform")
endif()


add_executable(ContextokenizeX ${SOURCE_FILES})

target_include_directories(ContextokenizeX PRIVATE
    ${CMAKE_SOURCE_DIR}/filedlg
    ${CMAKE_SOURCE_DIR}/updater
    ${CMAKE_SOURCE_DIR}/core
)

if(WIN32)
    if(NOT DEFINED CMAKE_PREFIX_PATH)
        set(CMAKE_PREFIX_PATH $ENV{CMAKE_PREFIX_PATH})
    endif()
elseif(UNIX AND NOT APPLE)
    if(NOT DEFINED CMAKE_PREFIX_PATH)
        set(CMAKE_PREFIX_PATH $ENV{CMAKE_PREFIX_PATH})
    endif()
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Network Qml Core Gui Widgets Concurrent)

set_property(TARGET ContextokenizeX PROPERTY CXX_STANDARD 17)
set_property(TARGET ContextokenizeX PROPERTY CXX_STANDARD_REQUIRED ON)

qt_add_resources(RESOURCES resources/resources.qrc)
target_sources(ContextokenizeX PRIVATE ${RESOURCES})

target_link_libraries(ContextokenizeX PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Network Qt6::Qml Qt6::Widgets Qt6::Core Qt6::Gui Qt6::Concurrent)


if(WIN32)
    message(STATUS "Setting up Qt Quick deployment using windeployqt")
        set(WIN_ICON "${CMAKE_SOURCE_DIR}/winres/app_icon.ico")
    if(EXISTS "${WIN_ICON}")
        message(STATUS "Using Windows icon: ${WIN_ICON}")
        target_sources(ContextokenizeX PRIVATE "${CMAKE_SOURCE_DIR}/winres/winres.rc")
        set_target_properties(ContextokenizeX PROPERTIES
            WIN32_EXECUTABLE TRUE
            ICON "${WIN_ICON}"
        )
    else()
        message(FATAL_ERROR "Windows icon not found: ${WIN_ICON}")
    endif()
    if(NOT DEFINED QT_BIN_DIR)
        set(QT_BIN_DIR $ENV{QT_BIN_DIR})
    endif()
    if(NOT QT_BIN_DIR)
        message(FATAL_ERROR "Please set QT_BIN_DIR pointing to Qt bin folder with windeployqt.exe")
    endif()
    if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR MSVC_RUNTIME_LIBRARY MATCHES "Debug")
        set(WINDEPLOY_MODE "--debug")
    else()
        set(WINDEPLOY_MODE "--release")
    endif()

    add_custom_command(TARGET ContextokenizeX POST_BUILD
        COMMAND "${QT_BIN_DIR}/windeployqt.exe"
            ${WINDEPLOY_MODE}
            --qmldir "${CMAKE_SOURCE_DIR}"
            "$<TARGET_FILE:ContextokenizeX>"
        COMMENT "Running windeployqt (${WINDEPLOY_MODE}) to copy Qt Quick dependencies..."
    )

    add_custom_command(TARGET ContextokenizeX POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_SOURCE_DIR}/${UI}"
            "$<TARGET_FILE_DIR:ContextokenizeX>/${UI}"
        COMMENT " Copying ${UI} to output directory..."
    )

    message(STATUS " Qt Quick deployment configured successfully (using windeployqt).")
endif()

if(UNIX)
    string(ASCII 27 Esc)
    set(Green  "${Esc}[32m")
    set(Purple "${Esc}[35m")
    set(Reset  "${Esc}[0m")

        add_custom_command(TARGET ContextokenizeX POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_SOURCE_DIR}/${UI}"
            "$<TARGET_FILE_DIR:ContextokenizeX>/${UI}"
        COMMENT "Copying ${UI} to output directory..."
    )
    message(STATUS "${Purple} Project configured successfully on ${Green}${CMAKE_SYSTEM_NAME}${Reset}")

    if(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/ContextokenizeX" AND IS_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/ContextokenizeX")
        message(WARNING " Found directory named 'ContextokenizeX' in build folder. Removing to avoid linker conflict.")
        file(REMOVE_RECURSE "${CMAKE_CURRENT_BINARY_DIR}/ContextokenizeX")
    endif()

    if(CMAKE_BUILD_TYPE STREQUAL "Release" OR
   "    $<CONFIG>" STREQUAL "Release")
        #section is skipped since deployment is against the license rules for more information check "License" at https://github.com/anonyaro/ContextokenizeX
    else()
        message(STATUS " Debug build detected — skipping AppImage deployment.")
    endif()
endif()
