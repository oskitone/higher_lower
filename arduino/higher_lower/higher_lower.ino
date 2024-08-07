#include <Arduboy2.h>
#include <ArduboyTones.h>

# define MIN_FREQUENCY      20
# define MAX_FREQUENCY      20000

// TODO: increase
# define FREQUENCIES_COUNT  10

// NOTE: Yes, we start at 1, not 0.
# define STARTING_INDEX     1

// TODO: randomize
const uint16_t FREQUENCIES[] = {
  map(0, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
  map(100, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
  map(40, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
  map(60, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
  map(50, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
  map(58, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
  map(55, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
  map(57, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
  map(56, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
  map(56, 0, 100, MIN_FREQUENCY, MAX_FREQUENCY),
};

Arduboy2 arduboy;
ArduboyTones arduboyTones(arduboy.audio.enabled);

uint16_t frequencyIndex = STARTING_INDEX;

void setup() {
  arduboy.beginDoFirst();
  arduboy.waitNoButtons();

  arduboy.setFrameRate(15);
}

void drawDisplay() {
  arduboy.clear();
  arduboy.setCursor(2, 2);
  arduboy.print(frequencyIndex);
  arduboy.setCursor(2, 2 + 7 + 1);
  arduboy.print(FREQUENCIES[frequencyIndex]);
  arduboy.display();
}

void loop() {
  if (!arduboy.nextFrame()) {
    return;
  }

  arduboy.pollButtons();
  drawDisplay();

  if (arduboy.justPressed(B_BUTTON)) {
    frequencyIndex = constrain(
      frequencyIndex + 1,
      0, FREQUENCIES_COUNT - 1
    );
  }

  if (arduboy.justPressed(A_BUTTON)) {
    frequencyIndex = STARTING_INDEX;
  }
}
