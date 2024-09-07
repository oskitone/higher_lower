#include <Arduboy2.h>

Arduboy2 arduboy;

void setupInterface() {
  arduboy.beginDoFirst();
  arduboy.waitNoButtons();
}

void initRandomSeed() { arduboy.initRandomSeed(); }

void pollButtons() { arduboy.pollButtons(); }

inline bool justPressed(uint8_t button) { return arduboy.justPressed(button); }