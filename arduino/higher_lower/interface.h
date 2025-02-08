// NOTE: We're skipping Arduboy's initialization to
// get pinMode access to its buttons. I don't know
// the full consequence of that!

void setupInterface() {
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);

  pinMode(upPin, INPUT_PULLUP);
  pinMode(downPin, INPUT_PULLUP);
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

inline bool justPressed(uint8_t button) {
  // HACK: relying on tone delay to skip debouncing
  return digitalRead(button) == LOW;
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