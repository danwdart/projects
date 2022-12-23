cmake_minimum_required(VERSION 3.13)

include(pico_sdk_import.cmake)

project(pico C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_BUILD_TYPE Debug)

pico_sdk_init()

add_executable(shift_leds
        shift_leds.c
        )

target_link_libraries(shift_leds
        pico_stdlib              # for core functionality
        )

# enable usb output, disable uart output
pico_enable_stdio_usb(shift_leds 1)
pico_enable_stdio_uart(shift_leds 0)

# create map/bin/hex file etc.
pico_add_extra_outputs(shift_leds)

# add url via pico_set_program_url
# example_auto_set_url(shift_leds)
