// NOTE: This theme code isn't nearly as compact as it could be.
// That's fine! It's legible, at least, hopefully...

#include "pitches.h"

int16_t firstRoundTones[] = {
    NOTE_C5, NOTE_E5, NOTE_D5, NOTE_G5, NOTE_C5,
};

void _tone(int16_t t, int16_t duration) {
  if (t == NOTE_REST) {
    noTone(outputPin);
  } else {
    isPlayingSound = true;
    digitalWrite(ledPin, LOW);
    tone(outputPin, t, duration);
  }

  _delay(duration);
  digitalWrite(ledPin, HIGH);
  isPlayingSound = false;
}

inline int16_t getDuration(int16_t duration, uint8_t progress) {
  return max(minToneOrIntervalPauseDuration,
             duration * pow(durationDiminish, progress));
}

void playInterval(int16_t tone1, int16_t tone2, uint8_t progress) {
  _delay(preIntervalPause);

  _tone(tone1, getDuration(lastToneDuration, progress));
  _delay(getDuration(midIntervalPause, progress));
  _tone(tone2, getDuration(currentToneDuration, progress));
}

void _theme_tone(int16_t t) { _tone(t, themeNoteLength); }
void _theme_tone(int16_t t, float speed) { _tone(t, themeNoteLength / speed); }

void playThemeCountIn(uint8_t count) {
  for (uint8_t i = 0; i < count; i++) {
    _theme_tone(NOTE_G5);
    _theme_tone(NOTE_REST);
  }
}

void playThemeCountInWithDescent(uint8_t count) {
  for (uint8_t i = 0; i < count; i++) {
    _theme_tone(NOTE_G5);
    _theme_tone(NOTE_REST);
  }

  _theme_tone(NOTE_G5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_F5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_E5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_D5);
  _theme_tone(NOTE_REST);
}

void playThemeMotif(float speed) {
  _theme_tone(NOTE_C5, speed);
  _theme_tone(NOTE_REST, speed);
  _theme_tone(NOTE_E5, speed);
  _theme_tone(NOTE_D5, speed);
  _theme_tone(NOTE_REST, speed);
  _theme_tone(NOTE_F5, speed);
  _theme_tone(NOTE_REST, speed);
  _theme_tone(NOTE_E5, speed);
  _theme_tone(NOTE_REST, speed);
  _theme_tone(NOTE_G5, speed);
  _theme_tone(NOTE_REST, speed);
  _theme_tone(NOTE_F5, speed);
  _theme_tone(NOTE_A5, speed);
  _theme_tone(NOTE_REST, speed);
  _theme_tone(NOTE_G5, speed);
  _theme_tone(NOTE_REST, speed);
}

void playThemeMotifEnd() {
  _theme_tone(NOTE_C5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_C6);
  _theme_tone(NOTE_C5);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_C6);
  _theme_tone(NOTE_REST);
  _theme_tone(NOTE_C4);
}

void playIntro(uint8_t count) {
  playThemeCountIn(count);
  playThemeMotif(1);
  playThemeMotifEnd();
}

// KNOWN ISSUE: This is super gnarly (but not broken!) in emulator.
void playWinnerSong(uint8_t count) {
  playThemeCountInWithDescent(4);
  for (uint8_t i = 0; i < 255; i++) {
    playThemeMotif(pow(themeMotifSpeedup, i));
  }
  playThemeCountIn(count);
  playThemeMotifEnd();
}

void playSuccessSound(uint8_t count) {
  for (uint8_t i = 0; i < count; i++) {
    _tone(NOTE_G3, 17);
    _tone(NOTE_C4, 34);
    _tone(NOTE_E4, 34);
    _tone(NOTE_C5, 68);

    if ((i + 1) % 5 == 0) {
      _delay(68 * 2);
    }
  }
}

void playGameOverSound(uint8_t count) {
  _tone(NOTE_G2, resetPause);
  _delay(resetPause);

  for (uint8_t i = 0; i < count; i++) {
    _tone(NOTE_C4, 17);
    _tone(NOTE_E3, 34);
    _tone(NOTE_C3, 34);
    _tone(NOTE_G2, 68);

    if ((i + 1) % 5 == 0) {
      _delay(68 * 2);
    }
  }
}