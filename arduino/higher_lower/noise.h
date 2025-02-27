// NOTE: This theme code isn't nearly as compact as it could be.
// That's fine! It's legible, at least, hopefully...

#include "pitches.h"

int16_t firstRoundTones[] = {
    NOTE_C5, NOTE_E5, NOTE_D5, NOTE_G5, NOTE_C5,
};

void _tone(int16_t t, int16_t duration, bool &isPlayingSound) {
  if (t == NOTE_REST) {
    noTone(outputPin);
  } else {
    isPlayingSound = true;
    digitalWrite(ledPin, LOW);
    tone(outputPin, t, duration);
  }

  _delay(duration, isPlayingSound);
  digitalWrite(ledPin, HIGH);
  isPlayingSound = false;
}

inline int16_t getDuration(int16_t duration, uint8_t progress) {
  return max(minToneOrIntervalPauseDuration,
             duration * pow(durationDiminish, progress));
}

void playInterval(int16_t tone1, int16_t tone2, uint8_t progress,
                  bool &isPlayingSound) {
  _delay(preIntervalPause);

  _tone(tone1, getDuration(lastToneDuration, progress), isPlayingSound);
  _delay(getDuration(midIntervalPause, progress));
  _tone(tone2, getDuration(currentToneDuration, progress), isPlayingSound);
}

void _theme_tone(int16_t t, bool &isPlayingSound) {
  _tone(t, themeNoteLength, isPlayingSound);
}
void _theme_tone(int16_t t, float speed, bool &isPlayingSound) {
  _tone(t, themeNoteLength / speed, isPlayingSound);
}

void playThemeCountIn(uint8_t count, bool &isPlayingSound) {
  for (uint8_t i = 0; i < count; i++) {
    _theme_tone(NOTE_G5, isPlayingSound);
    _theme_tone(NOTE_REST, isPlayingSound);
  }
}

void playThemeCountInWithDescent(uint8_t count, bool &isPlayingSound) {
  for (uint8_t i = 0; i < count; i++) {
    _theme_tone(NOTE_G5, isPlayingSound);
    _theme_tone(NOTE_REST, isPlayingSound);
  }

  _theme_tone(NOTE_G5, isPlayingSound);
  _theme_tone(NOTE_REST, isPlayingSound);
  _theme_tone(NOTE_F5, isPlayingSound);
  _theme_tone(NOTE_REST, isPlayingSound);
  _theme_tone(NOTE_E5, isPlayingSound);
  _theme_tone(NOTE_REST, isPlayingSound);
  _theme_tone(NOTE_D5, isPlayingSound);
  _theme_tone(NOTE_REST, isPlayingSound);
}

void playThemeMotif(float speed, bool &isPlayingSound) {
  _theme_tone(NOTE_C5, speed, isPlayingSound);
  _theme_tone(NOTE_REST, speed, isPlayingSound);
  _theme_tone(NOTE_E5, speed, isPlayingSound);
  _theme_tone(NOTE_D5, speed, isPlayingSound);
  _theme_tone(NOTE_REST, speed, isPlayingSound);
  _theme_tone(NOTE_F5, speed, isPlayingSound);
  _theme_tone(NOTE_REST, speed, isPlayingSound);
  _theme_tone(NOTE_E5, speed, isPlayingSound);
  _theme_tone(NOTE_REST, speed, isPlayingSound);
  _theme_tone(NOTE_G5, speed, isPlayingSound);
  _theme_tone(NOTE_REST, speed, isPlayingSound);
  _theme_tone(NOTE_F5, speed, isPlayingSound);
  _theme_tone(NOTE_A5, speed, isPlayingSound);
  _theme_tone(NOTE_REST, speed, isPlayingSound);
  _theme_tone(NOTE_G5, speed, isPlayingSound);
  _theme_tone(NOTE_REST, speed, isPlayingSound);
}

void playThemeMotifEnd(bool &isPlayingSound) {
  _theme_tone(NOTE_C5, isPlayingSound);
  _theme_tone(NOTE_REST, isPlayingSound);
  _theme_tone(NOTE_C6, isPlayingSound);
  _theme_tone(NOTE_C5, isPlayingSound);
  _theme_tone(NOTE_REST, isPlayingSound);
  _theme_tone(NOTE_C6, isPlayingSound);
  _theme_tone(NOTE_REST, isPlayingSound);
  _theme_tone(NOTE_C4, isPlayingSound);
}

void playIntro(uint8_t count, bool &isPlayingSound) {
  playThemeCountIn(count, isPlayingSound);
  playThemeMotif(1, isPlayingSound);
  playThemeMotifEnd(isPlayingSound);
}

void playWinnerSong(uint8_t count, bool &isPlayingSound) {
  playThemeCountInWithDescent(4, isPlayingSound);
  for (uint8_t i = 0; i < 255; i++) {
    playThemeMotif(pow(themeMotifSpeedup, i), isPlayingSound);
  }
  playThemeCountIn(count, isPlayingSound);
  playThemeMotifEnd(isPlayingSound);
}

void playSuccessSound(uint8_t count, bool &isPlayingSound) {
  for (uint8_t i = 0; i < count; i++) {
    _tone(NOTE_G3, 17, isPlayingSound);
    _tone(NOTE_C4, 34, isPlayingSound);
    _tone(NOTE_E4, 34, isPlayingSound);
    _tone(NOTE_C5, 68, isPlayingSound);

    if ((i + 1) % 5 == 0) {
      _delay(68 * 2);
    }
  }
}

void playGameOverSound(uint8_t count, bool &isPlayingSound) {
  _tone(NOTE_G2, resetPause, isPlayingSound);
  _delay(resetPause);

  for (uint8_t i = 0; i < count; i++) {
    _tone(NOTE_C4, 17, isPlayingSound);
    _tone(NOTE_E3, 34, isPlayingSound);
    _tone(NOTE_C3, 34, isPlayingSound);
    _tone(NOTE_G2, 68, isPlayingSound);

    if ((i + 1) % 5 == 0) {
      _delay(68 * 2);
    }
  }
}