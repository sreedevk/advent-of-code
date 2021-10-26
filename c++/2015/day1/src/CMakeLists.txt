cmake_minimum_required(VERSION 3.18)
project(notQuiteLisp)

find_package(Boost 1.75 COMPONENTS program_options REQUIRED)

include_directories(${Boost_INCLUDE_DIR})
add_executable(${CMAKE_PROJECT_NAME} main.cpp)
target_link_libraries(${CMAKE_PROJECT_NAME} LINK_PUBLIC ${Boost_LIBRARIES})

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/data.txt DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/)
