##################################################    Project     ##################################################
cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
project               (uci VERSION 1.0 LANGUAGES CXX)
list                  (APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
set_property          (GLOBAL PROPERTY USE_FOLDERS ON)

##################################################    Options     ##################################################
option(BUILD_TESTS "Build tests." OFF)

##################################################    Sources     ##################################################
set(PROJECT_SOURCES
  CMakeLists.txt
  cmake/assign_source_group.cmake
  cmake/import_library.cmake 
  docs/protocol.txt
  include/uci/uci.hpp
  license.txt
  readme.md
)
include(assign_source_group)
assign_source_group(${PROJECT_SOURCES})

##################################################  Dependencies  ##################################################
include(import_library)

find_package  (Boost REQUIRED)
import_library(Boost_INCLUDE_DIRS)

##################################################    Targets     ##################################################
add_library(${PROJECT_NAME} INTERFACE)
target_include_directories(${PROJECT_NAME} INTERFACE 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
  $<INSTALL_INTERFACE:include>)
target_include_directories(${PROJECT_NAME} INTERFACE ${PROJECT_INCLUDE_DIRS})
target_link_libraries     (${PROJECT_NAME} INTERFACE ${PROJECT_LIBRARIES})

# Hack for header-only project to appear in the IDEs.
add_library(${PROJECT_NAME}_ STATIC ${PROJECT_SOURCES})
target_include_directories(${PROJECT_NAME}_ 
  PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_BINARY_DIR})     
target_include_directories(${PROJECT_NAME}_ PUBLIC ${PROJECT_INCLUDE_DIRS})
target_link_libraries     (${PROJECT_NAME}_ PUBLIC ${PROJECT_LIBRARIES})
set_target_properties     (${PROJECT_NAME}_ PROPERTIES LINKER_LANGUAGE CXX)

##################################################    Testing     ##################################################
if(BUILD_TESTS)
  enable_testing()

  set(PROJECT_TEST_SOURCES

  )

  foreach(_SOURCE ${PROJECT_TEST_SOURCES})
    get_filename_component(_NAME ${_SOURCE} NAME_WE)
    set                   (_SOURCES tests/catch.hpp tests/main.cpp ${_SOURCE})
    add_executable        (${_NAME} ${_SOURCES})
    target_link_libraries (${_NAME} ${PROJECT_NAME})
    add_test              (${_NAME} ${_NAME})
    set_property          (TARGET ${_NAME} PROPERTY FOLDER "Tests")
    source_group          ("source" FILES ${_SOURCES})
  endforeach()
endif()

##################################################  Installation  ##################################################
install(TARGETS ${PROJECT_NAME} EXPORT "${PROJECT_NAME}-config")
install(DIRECTORY include/ DESTINATION include)
install(EXPORT  "${PROJECT_NAME}-config" DESTINATION "cmake")
export (TARGETS "${PROJECT_NAME}"        FILE        "${PROJECT_NAME}-config.cmake")
