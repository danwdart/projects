/**
 * Buzzer demo
 * 
 * @author Dan Dart
 */

#include <stdio.h>
#include <stdlib.h>
#include "pico/stdlib.h"

#define BUZZER_ACTIVE 17
#define BUZZER_PASSIVE 16

void setup() {
    stdio_init_all();

    gpio_init(BUZZER_ACTIVE);
    gpio_init(BUZZER_PASSIVE);
    
    gpio_set_dir(BUZZER_ACTIVE, GPIO_OUT);
    gpio_set_dir(BUZZER_PASSIVE, GPIO_OUT);

    gpio_put(BUZZER_ACTIVE, 0);
    gpio_put(BUZZER_PASSIVE, 0);
}

void loop() {
    // bip, bip...
    gpio_put(BUZZER_ACTIVE, 1);
    sleep_ms(50);
    gpio_put(BUZZER_ACTIVE, 0);
    sleep_ms(950);

    // meeeeehhhhh
    
    // gpio_put(BUZZER_PASSIVE, 1);
    // sleep_ms(1);
    // gpio_put(BUZZER_PASSIVE, 0);
    // sleep_ms(1);
}

int main() {
    setup();
    while (true) {
        loop();
    }
}