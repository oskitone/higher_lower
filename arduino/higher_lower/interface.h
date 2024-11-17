// NOTE: We're skipping Arduboy's initialization to
// get pinMode access to its buttons. I don't know
// the full consequence of that!

void setupInterface() {
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);

  pinMode(upPin, INPUT_PULLUP);
  pinMode(downPin, INPUT_PULLUP);
}

uint8_t getDifficulty() {
#ifdef __AVR_ATtiny85__ -
  return map(analogRead(ctrlPin), 0, 1023, minDifficulty, maxDifficulty);
#else
  return defaultDifficulty;
#endif
}

// NOTE: this works much better on real hardware than emulator
void initRandomSeed() { randomSeed(analogRead(seedPin)); }

inline bool justPressed(uint8_t button) {
  // HACK: relying on tone delay to skip debouncing
  return digitalRead(button) == LOW;
}

void setupSerial() {
#ifndef __AVR_ATtiny85__
  Serial.begin(9600);
#endif
}

void printBlankLineToSerial() {
#ifndef __AVR_ATtiny85__
  Serial.println();
#endif
}

void printRoundToSerial(uint8_t roundsWon) {
#ifndef __AVR_ATtiny85__
  Serial.print(F("ROUND "));
  Serial.print(roundsWon);

  Serial.println();
#endif
}

uint8_t printIntervalToSerial(uint8_t i, int16_t *tones) {
#ifndef __AVR_ATtiny85__
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

void printAllTones(int16_t *tones) {
#ifndef __AVR_ATtiny85__
  for (uint8_t i = 0; i < guessesPerRound; i++) {
    Serial.print(i);
    Serial.print(": ");
    Serial.println(tones[i]);
  }
#endif
}
