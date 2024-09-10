#include "pitches.h"

void _tone(int16_t t, int16_t duration) {
  if (t == NOTE_REST) {
    noTone(SPKR_PIN);
  } else {
    digitalWrite(LED_PIN, HIGH);
    tone(SPKR_PIN, t, duration);
  }

  delay(duration);
  digitalWrite(LED_PIN, LOW);
}

void _tone(int16_t t) { _tone(t, THEME_NOTE_LENGTH); }

void playInterval(int16_t tone1, int16_t tone2, int8_t currentRound) {
  _tone(tone1, LAST_TONE_DURATION * pow(DIMINISH, currentRound));
  _tone(tone2, CURRENT_TONE_DURATION * pow(DIMINISH, currentRound));
}

void playIntro() {
  _tone(NOTE_C5);
  _tone(NOTE_REST);
  _tone(NOTE_E5);
  _tone(NOTE_D5);
  _tone(NOTE_REST);
  _tone(NOTE_F5);
  _tone(NOTE_REST);
  _tone(NOTE_E5);
  _tone(NOTE_REST);
  _tone(NOTE_G5);
  _tone(NOTE_REST);
  _tone(NOTE_F5);
  _tone(NOTE_A5);
  _tone(NOTE_REST);
  _tone(NOTE_G5);
  _tone(NOTE_REST);
  _tone(NOTE_C5);
  _tone(NOTE_REST);
  _tone(NOTE_C6);
  _tone(NOTE_C5);
  _tone(NOTE_REST);
  _tone(NOTE_C6);
  _tone(NOTE_REST);
  _tone(NOTE_C4);
}

void playSuccessSound(int8_t currentRound) {
  for (uint8_t i = 0; i <= currentRound; i++) {
    _tone(NOTE_G3, 17);
    _tone(NOTE_C4, 34);
    _tone(NOTE_E4, 34);
    _tone(NOTE_C5, 68);

    if ((i + 1) % SUCCESS_TONES_BUNCH == 0) {
      delay(SUCCESS_TONES_BREAK);
    }
  }
}

void playGameOverSound() {
  // play score
  for (uint8_t i = 0; i < 4; i++) {
    _tone(NOTE_G2, 136);
    _tone(NOTE_E2, 136);
    _tone(NOTE_B2, 136);
    _tone(NOTE_C2, 136);
  }
}