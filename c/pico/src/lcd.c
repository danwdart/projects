/**
 * Serial programmer
 * 
 * @author Dan Dart
 */

#include <stdio.h>
#include <stdlib.h>
#include "pico/stdlib.h"
#include "hardware/spi.h"

/* also spi0 */
#define LCD_CS 17
#define LCD_RESET 20 
#define LCD_DCRS 21
#define LCD_MOSI 19
#define LCD_SCK 18
#define LCD_LED 27
#define LCD_MISO 16


#define ILI9341_TFTWIDTH 240  ///< ILI9341 max TFT width
#define ILI9341_TFTHEIGHT 320 ///< ILI9341 max TFT height

#define ILI9341_NOP 0x00     ///< No-op register
#define ILI9341_SWRESET 0x01 ///< Software reset register
#define ILI9341_RDDID 0x04   ///< Read display identification information
#define ILI9341_RDDST 0x09   ///< Read Display Status

#define ILI9341_SLPIN 0x10  ///< Enter Sleep Mode
#define ILI9341_SLPOUT 0x11 ///< Sleep Out
#define ILI9341_PTLON 0x12  ///< Partial Mode ON
#define ILI9341_NORON 0x13  ///< Normal Display Mode ON

#define ILI9341_RDMODE 0x0A     ///< Read Display Power Mode
#define ILI9341_RDMADCTL 0x0B   ///< Read Display MADCTL
#define ILI9341_RDPIXFMT 0x0C   ///< Read Display Pixel Format
#define ILI9341_RDIMGFMT 0x0D   ///< Read Display Image Format
#define ILI9341_RDSELFDIAG 0x0F ///< Read Display Self-Diagnostic Result

#define ILI9341_INVOFF 0x20   ///< Display Inversion OFF
#define ILI9341_INVON 0x21    ///< Display Inversion ON
#define ILI9341_GAMMASET 0x26 ///< Gamma Set
#define ILI9341_DISPOFF 0x28  ///< Display OFF
#define ILI9341_DISPON 0x29   ///< Display ON

#define ILI9341_CASET 0x2A ///< Column Address Set
#define ILI9341_PASET 0x2B ///< Page Address Set
#define ILI9341_RAMWR 0x2C ///< Memory Write
#define ILI9341_RAMRD 0x2E ///< Memory Read

#define ILI9341_PTLAR 0x30    ///< Partial Area
#define ILI9341_VSCRDEF 0x33  ///< Vertical Scrolling Definition
#define ILI9341_MADCTL 0x36   ///< Memory Access Control
#define ILI9341_VSCRSADD 0x37 ///< Vertical Scrolling Start Address
#define ILI9341_PIXFMT 0x3A   ///< COLMOD: Pixel Format Set

#define ILI9341_FRMCTR1                                                        \
  0xB1 ///< Frame Rate Control (In Normal Mode/Full Colors)
#define ILI9341_FRMCTR2 0xB2 ///< Frame Rate Control (In Idle Mode/8 colors)
#define ILI9341_FRMCTR3                                                        \
  0xB3 ///< Frame Rate control (In Partial Mode/Full Colors)
#define ILI9341_INVCTR 0xB4  ///< Display Inversion Control
#define ILI9341_DFUNCTR 0xB6 ///< Display Function Control

#define ILI9341_PWCTR1 0xC0 ///< Power Control 1
#define ILI9341_PWCTR2 0xC1 ///< Power Control 2
#define ILI9341_PWCTR3 0xC2 ///< Power Control 3
#define ILI9341_PWCTR4 0xC3 ///< Power Control 4
#define ILI9341_PWCTR5 0xC4 ///< Power Control 5
#define ILI9341_VMCTR1 0xC5 ///< VCOM Control 1
#define ILI9341_VMCTR2 0xC7 ///< VCOM Control 2

#define ILI9341_RDID1 0xDA ///< Read ID 1
#define ILI9341_RDID2 0xDB ///< Read ID 2
#define ILI9341_RDID3 0xDC ///< Read ID 3
#define ILI9341_RDID4 0xDD ///< Read ID 4

#define ILI9341_GMCTRP1 0xE0 ///< Positive Gamma Correction
#define ILI9341_GMCTRN1 0xE1 ///< Negative Gamma Correction
//#define ILI9341_PWCTR6     0xFC

// Color definitions
#define ILI9341_BLACK 0x0000       ///<   0,   0,   0
#define ILI9341_NAVY 0x000F        ///<   0,   0, 123
#define ILI9341_DARKGREEN 0x03E0   ///<   0, 125,   0
#define ILI9341_DARKCYAN 0x03EF    ///<   0, 125, 123
#define ILI9341_MAROON 0x7800      ///< 123,   0,   0
#define ILI9341_PURPLE 0x780F      ///< 123,   0, 123
#define ILI9341_OLIVE 0x7BE0       ///< 123, 125,   0
#define ILI9341_LIGHTGREY 0xC618   ///< 198, 195, 198
#define ILI9341_DARKGREY 0x7BEF    ///< 123, 125, 123
#define ILI9341_BLUE 0x001F        ///<   0,   0, 255
#define ILI9341_GREEN 0x07E0       ///<   0, 255,   0
#define ILI9341_CYAN 0x07FF        ///<   0, 255, 255
#define ILI9341_RED 0xF800         ///< 255,   0,   0
#define ILI9341_MAGENTA 0xF81F     ///< 255,   0, 255
#define ILI9341_YELLOW 0xFFE0      ///< 255, 255,   0
#define ILI9341_WHITE 0xFFFF       ///< 255, 255, 255
#define ILI9341_ORANGE 0xFD20      ///< 255, 165,   0
#define ILI9341_GREENYELLOW 0xAFE5 ///< 173, 255,  41
#define ILI9341_PINK 0xFC18        ///< 255, 130, 198

#define MADCTL_MY 0x80  ///< Bottom to top
#define MADCTL_MX 0x40  ///< Right to left
#define MADCTL_MV 0x20  ///< Reverse Mode
#define MADCTL_ML 0x10  ///< LCD refresh Bottom to top
#define MADCTL_RGB 0x00 ///< Red-Green-Blue pixel order
#define MADCTL_BGR 0x08 ///< Blue-Green-Red pixel order
#define MADCTL_MH 0x04  ///< LCD refresh right to left

void setup() {
    stdio_init_all();

    sleep_ms(3000);

    printf("Hello world!\n");

    spi_init(spi0, 48000);

    gpio_init(LCD_DCRS);
    gpio_init(LCD_LED);
    gpio_init(LCD_RESET);

    gpio_set_dir(LCD_DCRS, GPIO_OUT);
    gpio_set_dir(LCD_LED, GPIO_OUT);
    gpio_set_dir(LCD_RESET, GPIO_OUT);

    gpio_put(LCD_DCRS, 1); // high = reg, low = data
    gpio_put(LCD_RESET, 1); // low level reset
    gpio_put(LCD_LED, 1); // backlight

    uint8_t commands[] = {
      0xEF, 3, 0x03, 0x80, 0x02,
      0xCF, 3, 0x00, 0xC1, 0x30,
      0xED, 4, 0x64, 0x03, 0x12, 0x81,
      0xE8, 3, 0x85, 0x00, 0x78,
      0xCB, 5, 0x39, 0x2C, 0x00, 0x34, 0x02,
      0xF7, 1, 0x20,
      0xEA, 2, 0x00, 0x00,
      ILI9341_PWCTR1  , 1, 0x23,             // Power control VRH[5:0]
      ILI9341_PWCTR2  , 1, 0x10,             // Power control SAP[2:0];BT[3:0]
      ILI9341_VMCTR1  , 2, 0x3e, 0x28,       // VCM control
      ILI9341_VMCTR2  , 1, 0x86,             // VCM control2
      ILI9341_MADCTL  , 1, MADCTL_MX | MADCTL_BGR,             // Memory Access Control
      ILI9341_VSCRSADD, 1, 0x00,             // Vertical scroll zero
      ILI9341_PIXFMT  , 1, 0x55,
      ILI9341_FRMCTR1 , 2, 0x00, 0x18,
      ILI9341_DFUNCTR , 3, 0x08, 0x82, 0x27, // Display Function Control
      0xF2, 1, 0x00,                         // 3Gamma Function Disable
      ILI9341_GAMMASET , 1, 0x01,             // Gamma curve selected
      ILI9341_GMCTRP1 , 15, 0x0F, 0x31, 0x2B, 0x0C, 0x0E, 0x08, // Set Gamma
        0x4E, 0xF1, 0x37, 0x07, 0x10, 0x03, 0x0E, 0x09, 0x00,
      ILI9341_GMCTRN1 , 15, 0x00, 0x0E, 0x14, 0x03, 0x11, 0x07, // Set Gamma
        0x31, 0xC1, 0x48, 0x08, 0x0F, 0x0C, 0x31, 0x36, 0x0F,
      ILI9341_SLPOUT  , 0x80,                // Exit Sleep
      ILI9341_DISPON  , 0x80,                // Display on
      0x00                                   // End of list
      , ILI9341_RAMWR
    };

    // uint8_t result[8];

    printf("Sending SPI commands\n");

    spi_write_blocking(spi0, commands, sizeof(commands) / sizeof(uint8_t));

    printf("Setup complete\n");

    gpio_put(LCD_DCRS, 0); // high = reg, low = data

    uint16_t graphics[] = {
      ILI9341_MAROON,
      ILI9341_MAROON,
      ILI9341_MAROON,
      ILI9341_MAROON,
      ILI9341_MAROON,
      ILI9341_MAROON,
      ILI9341_MAROON,
      ILI9341_MAROON
    };

    printf("Sending SPI data\n");

    spi_write16_blocking(spi0, graphics, sizeof(graphics) / sizeof(uint16_t));

    printf("Done!\n");

    /*
    printf(
      "OUT: %02x%02x%02x%02x%02x%02x%02x%02x IN: %02x%02x%02x%02x%02x%02x%02x%02x\n",
      commands[0],
      commands[1],
      commands[2],
      commands[3],
      commands[4],
      commands[5],
      commands[6],
      commands[7],
      result[0],
      result[1],
      result[2],
      result[3],
      result[4],
      result[5],
      result[6],
      result[7]
    );
    */
    
}

void loop() {
    while (true) {

    }
}

int main() {
    setup();
    loop();
}