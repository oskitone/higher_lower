#ifndef __AVR_ATtiny85__
#include <Arduboy2.h>

#include "graphics.h"

Arduboy2 arduboy;
#endif

bool isPlayingSound = false;

void setupInterface() {
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);

  pinMode(upPin, INPUT_PULLUP);
  pinMode(downPin, INPUT_PULLUP);

#ifndef __AVR_ATtiny85__
  arduboy.begin();
#endif
}

void updateDisplay(bool isPlayingSound = false, Intent intent = Intent::NONE) {
#ifndef __AVR_ATtiny85__
  arduboy.clear();

  Sprites::drawOverwrite(32, 1, machine, 0);

  if (isPlayingSound) {
    Sprites::drawOverwrite(21, 8, sound, 0);
    arduboy.fillRect(39, 8, 2, 2);
  }

  if (intent == Intent::UP) {
    arduboy.fillRect(77, 14, 4, 3);
  }

  if (intent == Intent::DOWN) {
    arduboy.fillRect(77, 24, 4, 3);
  }

  arduboy.display();
#endif
}

// HACK: Work around delay blocking display updates...
// This would be lousy for more complex graphics, but
// seems fine here.
void _delay(int16_t duration, Intent intent = Intent::NONE) {
  if (duration == 0) {
    return;
  }

  updateDisplay(isPlayingSound, intent);
  delay(duration);
  updateDisplay(isPlayingSound);
}

uint8_t getStartingDifficulty() {
#ifdef __AVR_ATtiny85__ -
  return map(analogRead(ctrlPin), 0, 1023, minStartingDifficulty,
             maxStartingDifficulty);
#else
  return defaultDifficulty;
#endif
}

void initRandomSeed() {
  unsigned long ms = millis();

#ifndef __AVR_ATtiny85__
  Serial.print("  SEED: ");
  Serial.println(ms);
#endif

  randomSeed(ms);
}

inline bool justPressed(Intent intent) {
  // HACK: relying on tone delay to skip debouncing

  if (intent == Intent::DOWN) {
    return digitalRead(downPin) == LOW;
  }

  if (intent == Intent::UP) {
    return digitalRead(upPin) == LOW;
  }

#ifndef __AVR_ATtiny85__
  if (intent == Intent::SKIP) {
    return (digitalRead(skipPins[0]) == LOW &&
            digitalRead(skipPins[1]) == LOW && digitalRead(skipPins[2]) == LOW);
  }
#endif

  return false;
}

void setupSerial() {
#ifndef __AVR_ATtiny85__
  Serial.begin(9600);

  // HACK: We need to wait a little before printing to the serial monitor. The
  // value here is MAGIC but seems to work.
  delay(10);
#endif
}

void printGameToSerial(uint8_t game, uint8_t difficulty) {
#ifndef __AVR_ATtiny85__
  Serial.print(F("GAME "));
  Serial.print(game);
  Serial.print(F("  DIFFICULTY "));
  Serial.print(difficulty);

  Serial.println();
#endif
}

void printRoundToSerial(uint8_t roundsWon, int16_t *tones) {
#ifndef __AVR_ATtiny85__
  Serial.print(F("  ROUND "));
  Serial.print(roundsWon);

  Serial.print(F(": "));
  for (uint8_t i = 0; i <= guessesPerRound; i++) {
    Serial.print(tones[i]);

    if (i < guessesPerRound) {
      Serial.print(F(","));
    }
  }

  Serial.println();
#endif
}

uint8_t printIntervalToSerial(uint8_t i, int16_t *tones) {
#ifndef __AVR_ATtiny85__
  Serial.print(F("    "));
  Serial.print(i);
  Serial.print(F(": "));
  Serial.print(tones[i - 1]);
  Serial.print(F(" -> "));
  Serial.print(tones[i]);
  Serial.print(F(" ("));
  Serial.print(tones[i] - tones[i - 1]);
  Serial.print(F(")"));
  Serial.println();
#endif

  // HACK: unused return response avoids compilation warning
  // when targeting ATtiny85
  return i;
}