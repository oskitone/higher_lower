#include "pitches.h"

#ifdef __AVR_ATtiny85__
#define SPKR_PIN 10 // TODO: replace
#else
#define SPKR_PIN 5
#endif

void _tone(int16_t t, int16_t duration) {
  tone(SPKR_PIN, t, duration);
  delay(duration);
}

void playInterval(int16_t tone1, int16_t tone2, int8_t currentRound) {
  _tone(tone1, LAST_TONE_DURATION * pow(DIMINISH, currentRound));
  _tone(tone2, CURRENT_TONE_DURATION * pow(DIMINISH, currentRound));
}

void playSuccessSound(int8_t currentRound) {
  for (uint8_t i = 0; i <= currentRound; i++) {
    _tone(NOTE_G3, 17);
    _tone(NOTE_C4, 34);
    _tone(NOTE_E4, 34);
    _tone(NOTE_C5, 68);
  }
}

void playGameOverSound() {
  for (uint8_t i = 0; i < 4; i++) {
    _tone(NOTE_G2, 136);
    _tone(NOTE_E2, 136);
    _tone(NOTE_B2, 136);
    _tone(NOTE_C2, 136);
  }
}