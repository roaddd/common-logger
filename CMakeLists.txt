cmake_minimum_required(VERSION 3.10)
project(common_logger VERSION 1.0 LANGUAGES C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_package(Threads REQUIRED)

add_library(logger_static STATIC src/logger.c)
add_library(logger_shared SHARED src/logger.c)

target_include_directories(logger_static PUBLIC ${PROJECT_SOURCE_DIR}/inc)
target_include_directories(logger_shared PUBLIC ${PROJECT_SOURCE_DIR}/inc)

set_target_properties(logger_static PROPERTIES OUTPUT_NAME logger)
set_target_properties(logger_shared PROPERTIES OUTPUT_NAME logger)

target_link_libraries(logger_shared PRIVATE Threads::Threads)

install(TARGETS logger_static logger_shared
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION lib
)
install(FILES inc/logger.h DESTINATION include)
