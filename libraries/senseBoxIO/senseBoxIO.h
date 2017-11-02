#define I2C_PWR 19  // PA05
#define SD_PWR 21   // PA07
#define UART_PWR 20 // PA06
#define XBEE1_PWR 5 // PB11
#define XBEE2_PWR 4 // PB10

#define MCU_CS_SD 28    // PA14
#define MCU_CS_XBEE1 24 // PA18
#define MCU_CS_XBEE2 6  // PA20

#include <Arduino.h>

class SenseBoxIO {
public:
  SenseBoxIO() {
    SPISelectNone();
    PowerI2C(false);
    PowerSDCard(false);
    PowerUART(false);
    PowerXBEE1(false);
    PowerXBEE2(false);
  }

  void PowerI2C(bool on) {
    pinMode(I2C_PWR, OUTPUT);
    digitalWrite(I2C_PWR,
                 (on) ? HIGH
                      : LOW); // turn Power on or off. Port is non inverted!
  }

  void PowerSDCard(bool on) {
    pinMode(SD_PWR, OUTPUT);
    digitalWrite(SD_PWR, (on) ? LOW : HIGH); // turn Power on or off
  }

  void PowerUART(bool on) {
    pinMode(UART_PWR, OUTPUT);
    digitalWrite(UART_PWR,
                 (on) ? HIGH
                      : LOW); // turn Power on or off. Port is non inverted!
  }

  void PowerXBEE1(bool on) {
    pinMode(XBEE1_PWR, OUTPUT);
    digitalWrite(XBEE1_PWR, (on) ? LOW : HIGH); // turn Power on or off
  }

  void PowerXBEE2(bool on) {
    pinMode(XBEE2_PWR, OUTPUT);
    digitalWrite(XBEE2_PWR, (on) ? LOW : HIGH); // turn Power on or off
  }

  void SPISelectNone(void) {
    pinMode(MCU_CS_XBEE1, OUTPUT);
    digitalWrite(MCU_CS_XBEE1, HIGH); // turn off

    pinMode(MCU_CS_XBEE2, OUTPUT);
    digitalWrite(MCU_CS_XBEE2, HIGH); // turn off

    pinMode(MCU_CS_SD, OUTPUT);
    digitalWrite(MCU_CS_SD, HIGH); // turn off
  }

  void SPISelectSDCard(void) {
    pinMode(MCU_CS_XBEE1, OUTPUT);
    digitalWrite(MCU_CS_XBEE1, HIGH); // turn off

    pinMode(MCU_CS_XBEE2, OUTPUT);
    digitalWrite(MCU_CS_XBEE2, HIGH); // turn off

    pinMode(MCU_CS_SD, OUTPUT);
    digitalWrite(MCU_CS_SD, LOW); // turn on
  }

  void SPISelectXBEE1(void) {
    pinMode(MCU_CS_XBEE2, OUTPUT);
    digitalWrite(MCU_CS_XBEE2, HIGH); // turn off

    pinMode(MCU_CS_SD, OUTPUT);
    digitalWrite(MCU_CS_SD, HIGH); // turn off

    pinMode(MCU_CS_XBEE1, OUTPUT);
    digitalWrite(MCU_CS_XBEE1, LOW); // turn on
  }

  void SPISelectXBEE2(void) {
    pinMode(MCU_CS_XBEE1, OUTPUT);
    digitalWrite(MCU_CS_XBEE1, HIGH); // turn off

    pinMode(MCU_CS_SD, OUTPUT);
    digitalWrite(MCU_CS_SD, HIGH); // turn off

    pinMode(MCU_CS_XBEE2, OUTPUT);
    digitalWrite(MCU_CS_XBEE2, LOW); // turn on
  }
};

static SenseBoxIO senseBoxIO;
