cmake_minimum_required(VERSION 3.10)
project(common_logger VERSION 1.0 LANGUAGES C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_library(logger STATIC src/logger.c)
target_include_directories(logger PUBLIC ${PROJECT_SOURCE_DIR}/inc)

install(TARGETS logger
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
install(FILES inc/logger.h DESTINATION include)
