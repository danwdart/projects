/**
 * Shift register LED demo
 * 
 * @author Dan Dart
 */

#include <stdio.h>
#include <stdlib.h>
#include "pico/stdlib.h"

/* Change these values to the GPIO pins that you attached your shift register to. */
#define SER_PIN 19
#define RCLK_PIN 20
#define SRCLK_PIN 18
#define SRCLR_PIN 21

#define RGB_LED_RED_PIN 6
#define RGB_LED_GREEN_PIN 8
#define RGB_LED_BLUE_PIN 9

#define BUTTON_1_PIN 2
#define BUTTON_2_PIN 5
#define BUTTON_3_PIN 11

#define DELAY_MS 0

typedef struct rgb {
    uint8_t red;
    uint8_t green;
    uint8_t blue;
} RGB;

typedef struct button_state {
    bool button1;
    bool button2;
    bool button3;
} BUTTONS_STATE;

BUTTONS_STATE buttons_state = {
    button1: 0,
    button2: 0,
    button3: 0
};

typedef struct led_pattern {
    char *name;
    void *perform_pattern;
    uint8_t count;
    bool enable;
} LED_PATTERN;

/**
 * Ugly "skipping" mechanic.
 */

bool paused = 0;
bool repeating = 0;
uint8_t pattern_number = 0;
uint8_t currently_running_led_pattern = 0;

void gpio_put_dbg(uint8_t pin, bool bit) {
    printf("Setting pin %d to %d\n", pin, bit);
    gpio_put(pin, bit);
}

void skippable_sleep_ms(int ms) {
    if (currently_running_led_pattern != pattern_number) {
        printf("Skipping sleep\n");
        return;
    }
    // printf("Sleeping %d ms\n", ms);
    sleep_ms(ms);
}

void skippable_pausable_gpio_put(uint8_t pin, bool bit) {
    while (paused) {
        printf("Paused, so sleeping 10ms\n");
        skippable_sleep_ms(10); /* this variable can be updated via irq */
    }
    if (currently_running_led_pattern != pattern_number) {
        printf("Skipping gpio_put.\n");
        return;
    }
    gpio_put(pin, bit);
}

void gpio_toggle_on_off(uint8_t pin) {
    skippable_pausable_gpio_put(pin, 1);
    skippable_pausable_gpio_put(pin, 0);
}

void skippable_pausable_shift_push_bit(bool bit) {
    while (paused) {
        skippable_sleep_ms(10); /* this variable can be updated via irq */
    }
    if (currently_running_led_pattern != pattern_number) {
        printf("Skipping skippable_pausable_shift_push_bit\n");
        return;
    }
    skippable_pausable_gpio_put(SER_PIN, bit);
    gpio_toggle_on_off(SRCLK_PIN);
    skippable_pausable_gpio_put(SER_PIN, 0); /* do we need to do this?*/
    gpio_toggle_on_off(RCLK_PIN);
}

void skippable_pausable_shift_push_byte(uint8_t byte) {
    if (currently_running_led_pattern != pattern_number) {
        printf("Skipping skippable_pausable_shift_push_byte\n");
        return;
    }
    for (int8_t bit_index = 8; bit_index >= 0; --bit_index) { /* guess you can't subtract uint8_ts */
        while (paused) {
            skippable_sleep_ms(10); /* this variable can be updated via irq */
        }
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping skippable_pausable_shift_push_byte from the inside\n");
            return;
        }
        skippable_pausable_gpio_put(SER_PIN, (byte >> bit_index) & 1);
        gpio_toggle_on_off(SRCLK_PIN);
        skippable_pausable_gpio_put(SER_PIN, 0); /* do we need to do this?*/
    }
    gpio_toggle_on_off(RCLK_PIN);
}

void led_long_snakes() {
    for (uint8_t bit_index = 0; bit_index < 8; bit_index++) {
        skippable_pausable_shift_push_bit(1);
        skippable_sleep_ms(50);
    }

    for (uint8_t bit_index = 0; bit_index < 8; bit_index++) {
        skippable_pausable_shift_push_bit(0);
        skippable_sleep_ms(50);
    }
}

void led_short_snakes() {
    for (uint8_t bit_index = 0; bit_index < 4; bit_index++) {
        skippable_pausable_shift_push_bit(1);
        skippable_sleep_ms(100);
    }

    for (uint8_t bit_index = 0; bit_index < 4; bit_index++) {
        skippable_pausable_shift_push_bit(0);
        skippable_sleep_ms(100);
    }
}

void led_bouncing_pattern() {
    for (uint8_t bit_index = 0; bit_index < 7; bit_index++) {
        skippable_pausable_shift_push_byte(1 << (8 - bit_index - 1));
        skippable_sleep_ms(100);
    }
    
    for (uint8_t bit_index = 0; bit_index < 7; bit_index++) {
        skippable_pausable_shift_push_byte(1 << bit_index);
        skippable_sleep_ms(100);
    }
}

void led_count_up_down() {
    for (uint8_t counter = 0; counter < 8; counter++) {
        skippable_pausable_shift_push_byte((1 << counter) - 1);
        skippable_sleep_ms(100);
    }

    for (int8_t counter = 8; counter >= 0; --counter) {
        skippable_pausable_shift_push_byte((1 << counter) - 1);
        skippable_sleep_ms(100);
    }
}

void led_counting() {
    for (uint16_t counter = 0; counter <= 255; counter++) { /* ??? */
        skippable_pausable_shift_push_byte(counter);
        skippable_sleep_ms(50);
    }
}

void led_fibonacci() {
    int a = 1;
    int b = 1;
    int c;
    
    skippable_pausable_shift_push_byte(a);
    skippable_sleep_ms(200);

    skippable_pausable_shift_push_byte(b);
    skippable_sleep_ms(200);

    for (int sequence_index = 0; sequence_index <= 9; sequence_index++)
    {
        c = a + b;

        skippable_pausable_shift_push_byte(b);
        skippable_sleep_ms(200);
        
        a = b;
        b = c;
    }
}

void led_lucas() {
    uint8_t a = 2;
    uint8_t b = 1;
    uint8_t c;
    
    skippable_pausable_shift_push_byte(a);
    skippable_sleep_ms(200);

    skippable_pausable_shift_push_byte(b);
    skippable_sleep_ms(200);

    for (uint8_t sequence_index = 0; sequence_index <= 9; sequence_index++)
    {
        c = a + b;

        skippable_pausable_shift_push_byte(b);
        skippable_sleep_ms(200);
        
        a = b;
        b = c;
    }
}

void led_alternating() {
    skippable_pausable_shift_push_byte(0b01010101);
    skippable_sleep_ms(200);

    skippable_pausable_shift_push_byte(0b10101010);
    skippable_sleep_ms(200);
}

void led_bouncing() {
    skippable_pausable_shift_push_byte(0b10000001);
    skippable_sleep_ms(200);

    skippable_pausable_shift_push_byte(0b01000010);
    skippable_sleep_ms(200);

    skippable_pausable_shift_push_byte(0b00100100);
    skippable_sleep_ms(200);

    skippable_pausable_shift_push_byte(0b00011000);
    skippable_sleep_ms(200);
    
    skippable_pausable_shift_push_byte(0b00100100);
    skippable_sleep_ms(200);

    skippable_pausable_shift_push_byte(0b01000010);
    skippable_sleep_ms(200);
}

void led_random() {
    skippable_pausable_shift_push_byte(rand());
    skippable_sleep_ms(100);
}

void led_increasing_snakes() {
    for (int snake_size = 0; snake_size < 8; snake_size++) {
        for (int bit_index = 0; bit_index < snake_size; bit_index++) {
            skippable_pausable_shift_push_bit(1);
            skippable_sleep_ms(100);
        }
        skippable_pausable_shift_push_bit(0);
        skippable_sleep_ms(100);
    }
}

void leds_set_brightness(int brightness, int max_brightness, int duration_steps, uint8_t low, uint8_t high) {
    for (int repeat_delay = 0; repeat_delay < duration_steps; repeat_delay++) {
        skippable_pausable_shift_push_byte(high);
        sleep_us(brightness);
        skippable_pausable_shift_push_byte(low);
        sleep_us(max_brightness - brightness);
    }
}

void leds_individual_set_brightness(int brightness[8], int max_brightness, int duration_steps) {
    if (currently_running_led_pattern != pattern_number) {
        printf("Skipping leds_individual_set_brightness from the real outside\n");
        return;
    }
    for (int repeat_delay = 0; repeat_delay < duration_steps; repeat_delay++) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping leds_individual_set_brightness from the other outside\n");
            return;
        }
        /**
         * e.g.
         * 0% 50% 50% 0% 0% 50% 25% 75% ->
         * 01100111
         * 01100101
         * 00000001
         * 00000000
        */
        for (int brightness_index = 0; brightness_index < max_brightness; brightness_index++) {

            if (currently_running_led_pattern != pattern_number) {
                printf("Skipping leds_individual_set_brightness from the outside\n");
                return;
            }
            // Construct the partial byte
            uint8_t partial_byte = 0;
            for (int bit_index = 0; bit_index < 8; bit_index++) {
                if (currently_running_led_pattern != pattern_number) {
                    printf("Skipping leds_individual_set_brightness from the inside\n");
                    return;
                }
                
                if (brightness[bit_index] > brightness_index) {
                    partial_byte = partial_byte | (1 << bit_index);
                }
            }
            skippable_pausable_shift_push_byte(partial_byte);
        }
    }
}

void rgb_set(RGB rgb, int duration_steps) {
    if (currently_running_led_pattern != pattern_number) {
        printf("Skipping rgb_set from the real outside\n");
        return;
    }
    for (int repeat_delay = 0; repeat_delay < duration_steps; repeat_delay++) { /* repeat to delay rather than using delays */
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping rgb_set from the outside\n");
            return;
        }
        for (int high_time = 0; high_time < 255; high_time++) {
            if (currently_running_led_pattern != pattern_number) {
                printf("Skipping rgb_set from the inside\n");
                return;
            }
            skippable_pausable_gpio_put(RGB_LED_RED_PIN, rgb.red >= high_time);
            skippable_pausable_gpio_put(RGB_LED_GREEN_PIN, rgb.green >= high_time);
            skippable_pausable_gpio_put(RGB_LED_BLUE_PIN, rgb.blue >= high_time);
        }
    }
}

void leds_slide_brightness(int from, int steps, int max_brightness, int8_t step, int time, uint8_t low, uint8_t high) {
    if (currently_running_led_pattern != pattern_number) {
        printf("Skipping leds_slide_brightness from the outside\n");
        return;
    }
    for (int current_step = from; current_step != steps; current_step += step) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping leds_slide_brightness from the inside\n");
            return;
        }
        leds_set_brightness(current_step, max_brightness, time, low, high);
    }
}

void rgb_rainbows() {
    int time = 100;

    RGB rgb = {
        red: 0,
        green: 0,
        blue: 0
    };

    /* B -> R */
    while (rgb.red < 255) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping rgb_rainbows\n");
            return;
        }

        rgb_set(rgb, time);
        rgb.red++;
    }

    /* R -> Y */
    while (rgb.green < 255) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping rgb_rainbows\n");
            return;
        }

        rgb_set(rgb, time);
        rgb.green++;
    }

    /* Y -> G */
    while (rgb.red > 0) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping rgb_rainbows\n");
            return;
        }

        rgb_set(rgb, time);
        rgb.red--;
    }

    /* G -> C */
    while (rgb.blue < 255) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping rgb_rainbows\n");
            return;
        }

        rgb_set(rgb, time);
        rgb.blue++;
    }

    /* C -> B */
    while (rgb.green > 0) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping rgb_rainbows\n");
            return;
        }

        rgb_set(rgb, time);
        rgb.green--;
    }

    /* B -> V */
    while (rgb.red < 255) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping rgb_rainbows\n");
            return;
        }

        rgb_set(rgb, time);
        rgb.red++;
    }

    /* V -> W */
    while (rgb.green < 255) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping rgb_rainbows\n");
            return;
        }

        rgb_set(rgb, time);
        rgb.green++;
    }

    /* W -> B */
    while (rgb.green > 0) {
        if (currently_running_led_pattern != pattern_number) {
            printf("Skipping rgb_rainbows\n");
            return;
        }

        rgb_set(rgb, time);
        rgb.red--;
        rgb.green--;
        rgb.blue--;
    }
}


void led_fake_brightness() {
    int steps = 100;
    int time = 200;

    leds_slide_brightness(0, steps, steps, 1, time, 0b00000000, 0b11111111);
    leds_slide_brightness(steps, 0, steps, -1, time, 0b00000000, 0b11111111);
}

void leds_wave() {
    int steps = 100;
    int time = 20;

    int brightnesses[8] = {0, 0, 0, 0, 0, 0, 0, 0};

    for (int bright_index = 0; bright_index < 8; bright_index++) {
        
        for (int step = 0; step < 100; step++) {
            if (bright_index > 0) {
                brightnesses[bright_index - 1]--;
            }
            brightnesses[bright_index]++;
            leds_individual_set_brightness(brightnesses, steps, time);
        }
    }
    // reset leds
    skippable_pausable_shift_push_byte(0);
}

/* todo */
void shift_reset() {

}

LED_PATTERN led_patterns[] = {
    {
        name: "Rainbows",
        perform_pattern: rgb_rainbows,
        count: 1,
        enable: 1
    },
    {
        name: "Long snakes",
        perform_pattern: led_long_snakes,
        count: 4,
        enable: 1
    },
    {
        name: "Short snakes",
        perform_pattern: led_short_snakes,
        count: 8,
        enable: 1
    },
    {
        name: "Bouncing pattern",
        perform_pattern: led_bouncing_pattern,
        count: 4,
        enable: 1
    },
    {
        name: "Counting up and down",
        perform_pattern: led_count_up_down,
        count: 4,
        enable: 1
    },
    {
        name: "Counting in binary",
        perform_pattern: led_counting,
        count: 1,
        enable: 1
    },
    {
        name: "Fibonacci",
        perform_pattern: led_fibonacci,
        count: 2,
        enable: 1
    },
    {
        name: "Lucas",
        perform_pattern: led_lucas,
        count: 2,
        enable: 1
    },
    {
        name: "Alternating pattern",
        perform_pattern: led_alternating,
        count: 4,
        enable: 1
    },
    {
        name: "Bouncing",
        perform_pattern: led_bouncing,
        count: 4,
        enable: 1
    },
    {
        name: "Random",
        perform_pattern: led_random,
        count: 64,
        enable: 1
    },
    {
        name: "Increasing snakes",
        perform_pattern: led_increasing_snakes,
        count: 2,
        enable: 1
    },
    {
        name: "Fake Brightness",
        perform_pattern: led_fake_brightness,
        count: 4,
        enable: 1
    },
    {
        name: "Wave",
        perform_pattern: leds_wave,
        count: 4,
        enable: 1
    }
};

uint8_t total_num_patterns = sizeof(led_patterns) / sizeof(LED_PATTERN);

void loop() {
    for (pattern_number = 0; pattern_number < total_num_patterns; pattern_number++) {
        currently_running_led_pattern = pattern_number;
        LED_PATTERN current_led_pattern = led_patterns[pattern_number];
        
        printf("%s\n", current_led_pattern.name);

        for (uint8_t pattern_iteration = 0; pattern_iteration < current_led_pattern.count; pattern_iteration++) {
            if (!current_led_pattern.enable) {
                break;
            }
            void (*run_pattern)() = current_led_pattern.perform_pattern;
            run_pattern();
            while (repeating) {
                run_pattern();
            }
        }
    }
}


void button_1_pressed() {
    printf("Button 1 pressed; %s.\n", paused ? "resuming" : "pausing"); /* @TODO: alarm for debouncing */
    // pause? resume?
    paused = !paused;
}

void button_1_released() {
    /* printf("Button 1 released\n"); */
}

void button_2_pressed() {
    printf("Button 2 pressed; skipping.\n");
    currently_running_led_pattern++;
    currently_running_led_pattern%=total_num_patterns;
    repeating = 0;
    paused = 0;
    // printf("Skipping to pattern %d\n", currently_running_led_pattern);
}

void button_2_released() {
    /* printf("Button 2 released\n"); */
}

void button_3_pressed() {
    printf("Button 3 pressed; toggling repeat.\n");
    repeating = !repeating;
    paused = 0;
}

void button_3_released() {
    /* printf("Button 3 released\n"); */
}

void irq_callback(uint gpio, uint32_t event_mask) {
    switch (gpio) {
        case BUTTON_1_PIN:
            if (event_mask & GPIO_IRQ_EDGE_RISE) {
                button_1_pressed();
            }
            if (event_mask & GPIO_IRQ_EDGE_FALL) {
                button_1_released();
            }
            break;
        case BUTTON_2_PIN:
            if (event_mask & GPIO_IRQ_EDGE_RISE) {
                button_2_pressed();
            }
            if (event_mask & GPIO_IRQ_EDGE_FALL) {
                button_2_released();
            }
            break;
        case BUTTON_3_PIN:
            if (event_mask & GPIO_IRQ_EDGE_RISE) {
                button_3_pressed();
            }
            if (event_mask & GPIO_IRQ_EDGE_FALL) {
                button_3_released();
            }
            break;
        default:
            break;
    }
}


void setup() {
    stdio_init_all();

    /* skippable_sleep_ms(2000); */ /* wait for serial */

    printf("Hi, we're set up.\n");

    gpio_init(SER_PIN);
    gpio_init(RCLK_PIN);
    gpio_init(SRCLK_PIN);
    gpio_init(SRCLR_PIN);
    gpio_init(RGB_LED_RED_PIN);
    gpio_init(RGB_LED_GREEN_PIN);
    gpio_init(RGB_LED_BLUE_PIN);

    printf("Setting directions of pins\n");

    gpio_set_dir(SER_PIN, GPIO_OUT);    
    gpio_set_dir(RCLK_PIN, GPIO_OUT);    
    gpio_set_dir(SRCLK_PIN, GPIO_OUT);    
    gpio_set_dir(SRCLR_PIN, GPIO_OUT);

    gpio_set_dir(RGB_LED_RED_PIN, GPIO_OUT);
    gpio_set_dir(RGB_LED_GREEN_PIN, GPIO_OUT);
    gpio_set_dir(RGB_LED_BLUE_PIN, GPIO_OUT);

    gpio_set_dir(BUTTON_1_PIN, GPIO_IN);
    gpio_set_dir(BUTTON_2_PIN, GPIO_IN);
    gpio_set_dir(BUTTON_3_PIN, GPIO_IN);

    gpio_pull_down(BUTTON_1_PIN);
    gpio_pull_down(BUTTON_2_PIN);
    gpio_pull_down(BUTTON_3_PIN);

    gpio_set_irq_enabled(BUTTON_1_PIN, GPIO_IRQ_EDGE_RISE | GPIO_IRQ_EDGE_FALL, 1);
    gpio_set_irq_enabled(BUTTON_2_PIN, GPIO_IRQ_EDGE_RISE | GPIO_IRQ_EDGE_FALL, 1);
    gpio_set_irq_enabled(BUTTON_3_PIN, GPIO_IRQ_EDGE_RISE | GPIO_IRQ_EDGE_FALL, 1);
    gpio_set_irq_callback(irq_callback);
    irq_set_enabled(IO_IRQ_BANK0, true);
    
    printf("Initing pins to default values\n");

    gpio_put(SER_PIN, 0);
    gpio_put(RCLK_PIN, 0);
    gpio_put(SRCLK_PIN, 0);
    /* active low */
    gpio_put(SRCLR_PIN, 1);

    gpio_put(RGB_LED_RED_PIN, 0);
    gpio_put(RGB_LED_GREEN_PIN, 0);
    gpio_put(RGB_LED_BLUE_PIN, 0);

    // Reset the shift register.
    skippable_pausable_shift_push_byte(0b00000000);
}

void run() {
    while (true) {
        loop();
    }
}

int main() {
    setup();
    run();
}
