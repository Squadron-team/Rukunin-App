cmake_minimum_required(VERSION 3.10.2)
project(feature_extractor)

add_library(
        feature_extractor
        SHARED
        feature_extractor.cpp
)

find_library(
        log-lib
        log
)

target_link_libraries(
        feature_extractor
        ${log-lib}
)
