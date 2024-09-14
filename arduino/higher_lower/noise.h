#include "pitches.h"

int16_t scale[] = {
    NOTE_C5, NOTE_D5, NOTE_E5, NOTE_F5, NOTE_G5, NOTE_A5, NOTE_B5, NOTE_C6,
};
#define SCALE_TONES_COUNT 8

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

inline int16_t getDuration(int16_t duration, uint8_t currentRound) {
  return max(MIN_TONE_OR_INTERVAL_PAUSE_DURATION,
             duration * pow(DURATION_DIMINISH, currentRound));
}

void playInterval(int16_t tone1, int16_t tone2, uint8_t currentRound) {
  delay(PRE_INTERVAL_PAUSE);

  _tone(tone1, getDuration(LAST_TONE_DURATION, currentRound));
  delay(getDuration(MID_INTERVAL_PAUSE, currentRound));
  _tone(tone1, getDuration(CURRENT_TONE_DURATION, currentRound));
  delay(getDuration(MID_INTERVAL_PAUSE, currentRound));
  _tone(tone2, getDuration(CURRENT_TONE_DURATION, currentRound));
}

void _theme_tone(int16_t t) { _tone(t, THEME_NOTE_LENGTH); }

void playIntro() {
  _theme_tone(NOTE_C5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_E5);
  _theme_tone(NOTE_D5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_F5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_E5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_G5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_F5);
  _theme_tone(NOTE_A5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_G5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_C5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_C6);
  _theme_tone(NOTE_C5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_C6);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_C4);
}

void playSuccessSound(uint8_t count) {
  for (uint8_t i = 0; i < count; i++) {
    _tone(NOTE_G3, 17);
    _tone(NOTE_C4, 34);
    _tone(NOTE_E4, 34);
    _tone(NOTE_C5, 68);

    if ((i + 1) % SUCCESS_TONES_BUNCH == 0) {
      delay(SUCCESS_TONES_BREAK);
    }
  }
}

void playGameOverSound(uint8_t count) {
  _tone(NOTE_G2, RESET_PAUSE);
  delay(RESET_PAUSE);

  for (uint8_t i = 0; i < count; i++) {
    _tone(NOTE_C4, 17);
    _tone(NOTE_E3, 34);
    _tone(NOTE_C3, 34);
    _tone(NOTE_G2, 68);

    if ((i + 1) % SUCCESS_TONES_BUNCH == 0) {
      delay(SUCCESS_TONES_BREAK);
    }
  }
}