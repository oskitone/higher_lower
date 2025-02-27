#include "consts.h"
#include "interface.h"
#include "noise.h"

#include "game.h"

void setup() {
  setupInterface();
  setupSerial();

  _delay(bootPause);

  reset();
}

void loop() {
  if (justPressed(Intent::DOWN)) {
    handleGuess(Intent::DOWN, tones[index] < tones[index - 1]);
  }

  if (justPressed(Intent::UP)) {
    handleGuess(Intent::UP, tones[index] > tones[index - 1]);
  }

  if (justPressed(Intent::SKIP)) {
    handleGuess(Intent::NONE, true, true);
  }
}
