/**
 * Serial programmer
 * 
 * @author Dan Dart
 */

#include <stdio.h>
#include <stdlib.h>
#include "pico/stdlib.h"
#include "hardware/spi.h"

#define AVR_SCK 14
#define AVR_MOSI 20
#define AVR_MISO 12
#define AVR_XTAL1 22
#define AVR_RESET 26

uint8_t prog_mode[4] = { 0xac, 0x53, 0x00, 0x00 };

/*
bool ser_push_pull_bit(bool bit) {
    gpio_put(AVR_XTAL1, 1);
    gpio_put(AVR_MOSI, bit);
    gpio_put(AVR_SCK, 1);
    gpio_put(AVR_SCK, 0);
    bool out = gpio_get(AVR_MISO);
    gpio_put(AVR_XTAL1, 0);
    
    printf("OUT: %x IN: %x\n", bit, out);
    return out;
}

uint8_t ser_push_pull_byte(uint8_t byte) {
    uint8_t out;
    for (uint8_t bit_index = 0; bit_index < 8; bit_index++) {
        out = out | (ser_push_pull_bit((byte >> bit_index) & 1) << (7 - bit_index));
    }
    printf("OUT: %02x IN: %02x\n", byte, out);
    return out;
}

void ser_push_pull_bytes(uint8_t input[4], uint8_t result[4], int bytes) {
    for (int byte_index = 0; byte_index < bytes; byte_index++) {
        result[byte_index] = ser_push_pull_byte(input[byte_index]);
        // printf("IN: %x OUT: %x\n", input[byte_index], result[byte_index]);
    }
}
*/

void setup() {
    stdio_init_all();

    printf("Waiting 3s for serial to turn on\n");

    sleep_ms(3000);

    printf("Hello! Initing xtal1 and reset\n");


    // gpio_init(AVR_MOSI);
    // gpio_init(AVR_MISO);
    // gpio_init(AVR_SCK);
    gpio_init(AVR_XTAL1);
    gpio_init(AVR_RESET);

    printf("Inited xtal1 and reset\n");

    // gpio_set_dir(AVR_MOSI, GPIO_OUT);
    // gpio_set_dir(AVR_MISO, GPIO_IN);
    // gpio_set_dir(AVR_SCK, GPIO_OUT);
    gpio_set_dir(AVR_XTAL1, GPIO_OUT);
    gpio_set_dir(AVR_RESET, GPIO_OUT);

    printf("Set xtal1 and reset as out\n");

    // gpio_put(AVR_MOSI, 0);
    // gpio_put(AVR_SCK, 0);
    gpio_put(AVR_XTAL1, 0);
    gpio_put(AVR_RESET, 1); /* active low */

    printf("Enabling Serial Download Mode\n");
    gpio_put(AVR_RESET, 0);

    // gpio_put(AVR_XTAL1, 0);
    sleep_us(100); // at least 2 clock cycles
    gpio_put(AVR_RESET, 1);

    // serial works while reset is ground
    gpio_put(AVR_RESET, 0);

    sleep_ms(100);
    // send programming enable

    spi_init(spi1, 48000);

    uint8_t result[4];

    while (true) {
        sleep_ms(1000);


        gpio_put(AVR_RESET, 1); /* active low */

        printf("Enabling Serial Download Mode\n");
        gpio_put(AVR_RESET, 0);

        // ser_push_pull_bytes(prog_mode, result, 4);

        // printf("Resetting\n");

        // gpio_put(AVR_RESET, 0); /* active low */
        // sleep_us(100); // at least 2 clock cycles
        // gpio_put(AVR_RESET, 1);

        // printf("Writing and reading\n");

        // gpio_put(AVR_XTAL1, 1);
        // spi_write_blocking(spi1, prog_mode, 4);
        // spi_read_blocking(spi1, 0, result, 4);

        spi_write_read_blocking(spi1, prog_mode, result, 4);
        // gpio_put(AVR_XTAL1, 0);
        
        printf(
            "OUT: %02x%02x%02x%02x IN: %02x%02x%02x%02x ...\n",
            prog_mode[0],
            prog_mode[1],
            prog_mode[2],
            prog_mode[3],
            result[0],
            result[1],
            result[2],
            result[3]
        );
    }
    // When writing, data clocked on rising edge. When reading, data clocked on falling edge

    // 001 0 0000 0000 0 1 00 1111 1110 0100
}

void loop() {
    while (true) {

    }
}

int main() {
    setup();
    loop();
}

// mosi miso sck xtal1 reset gnd vcc avcc