cmake_minimum_required(VERSION 3.22.1)

project("direwolf_decoder")

# Add Dire Wolf source files (core decoder only)
set(DIREWOLF_ROOT "C:/Users/Joshua/Downloads/direwolf/src")

# Core files needed for AFSK decoding
set(DIREWOLF_SOURCES
    ${DIREWOLF_ROOT}/demod_afsk.c
    ${DIREWOLF_ROOT}/demod.c
    ${DIREWOLF_ROOT}/hdlc_rec.c
    ${DIREWOLF_ROOT}/hdlc_rec2.c
    ${DIREWOLF_ROOT}/ax25_pad.c
    ${DIREWOLF_ROOT}/fcs_calc.c  
    ${DIREWOLF_ROOT}/rrbb.c
    ${DIREWOLF_ROOT}/multi_modem.c
    ${DIREWOLF_ROOT}/dsp.c
    ${DIREWOLF_ROOT}/textcolor.c
)

# JNI wrapper
add_library(${CMAKE_PROJECT_NAME} SHARED
    direwolf_jni.cpp
    ${DIREWOLF_SOURCES}
)

# Include directories
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    ${DIREWOLF_ROOT}
)

# Find and link log library
find_library(log-lib log)

target_link_libraries(${CMAKE_PROJECT_NAME}
    ${log-lib}
    android
)
