// NOTE: We're skipping Arduboy's initialization to
// get pinMode access to its buttons. I don't know
// the full consequence of that!

void setupInterface() {
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  pinMode(UP_PIN, INPUT_PULLUP);
  pinMode(DOWN_PIN, INPUT_PULLUP);
}

uint8_t getDifficulty() {
#ifdef __AVR_ATtiny85__ -
  return map(analogRead(CTRL_PIN), 0, 1023, MIN_DIFFICULTY, MAX_DIFFICULTY);
#else
  return DEFAULT_DIFFICULTY;
#endif
}

// NOTE: this works much better on real hardware than emulator
void initRandomSeed() { randomSeed(analogRead(SPKR_PIN)); }

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

void printLevelAndRoundToSerial(uint8_t level, uint8_t roundsWon) {
#ifndef __AVR_ATtiny85__
  Serial.print(F("LEVEL "));
  Serial.print(level + 1);
  Serial.print(F("  ROUND "));
  Serial.print((roundsWon % ROUNDS_PER_LEVEL) + 1);

  Serial.println();
#endif
}

uint8_t printIntervalToSerial(uint8_t i) {
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

void printAllTones() {
#ifndef __AVR_ATtiny85__
  for (uint8_t i = 0; i < GUESSES_PER_ROUND; i++) {
    Serial.print(i);
    Serial.print(": ");
    Serial.println(tones[i]);
  }
#endif
}
