// NOTE: We're skipping Arduboy's initialization to
// get pinMode access to its buttons. I don't know
// the full consequence of that!

void setupInterface() {
  pinMode(LED_PIN, OUTPUT);

  pinMode(UP_BUTTON, INPUT_PULLUP);
  pinMode(DOWN_BUTTON, INPUT_PULLUP);
  pinMode(RESET_BUTTON, INPUT_PULLUP);
}

void initRandomSeed() { randomSeed(millis()); }

inline bool justPressed(uint8_t button) {
  // HACK: relying on tone delay to skip debouncing
  return digitalRead(button) == LOW;
}