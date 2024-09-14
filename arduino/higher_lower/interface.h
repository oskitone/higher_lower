// NOTE: We're skipping Arduboy's initialization to
// get pinMode access to its buttons. I don't know
// the full consequence of that!

void setupInterface() {
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  pinMode(UP_BUTTON, INPUT_PULLUP);
  pinMode(DOWN_BUTTON, INPUT_PULLUP);
  pinMode(SKIP_BUTTON, INPUT_PULLUP);
}

void initRandomSeed() { randomSeed(millis()); }

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

uint8_t printRoundToSerial(uint8_t currentRound) {
#ifndef __AVR_ATtiny85__
  Serial.print(F("ROUND "));
  Serial.print(currentRound);
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
