#include <Arduboy2.h>
#include <ArduboyTones.h>

# define MIN_TONE       20
# define MAX_TONE       20000

// TODO: increase
# define TONE_COUNT     10

// NOTE: Yes, we start at 1, not 0.
# define STARTING_INDEX     1

// TODO: randomize
const uint16_t TONE[] = {
  map(0, 0, 100, MIN_TONE, MAX_TONE),
  map(100, 0, 100, MIN_TONE, MAX_TONE),
  map(40, 0, 100, MIN_TONE, MAX_TONE),
  map(60, 0, 100, MIN_TONE, MAX_TONE),
  map(50, 0, 100, MIN_TONE, MAX_TONE),
  map(58, 0, 100, MIN_TONE, MAX_TONE),
  map(55, 0, 100, MIN_TONE, MAX_TONE),
  map(57, 0, 100, MIN_TONE, MAX_TONE),
  map(56, 0, 100, MIN_TONE, MAX_TONE),
  map(56, 0, 100, MIN_TONE, MAX_TONE),
};

Arduboy2 arduboy;
ArduboyTones arduboyTones(arduboy.audio.enabled);

uint16_t index = STARTING_INDEX;

void setup() {
  arduboy.beginDoFirst();
  arduboy.waitNoButtons();

  arduboy.setFrameRate(15);
}

void drawDisplay() {
  arduboy.clear();
  arduboy.setCursor(2, 2);
  arduboy.print(index);
  arduboy.setCursor(2, 2 + 7 + 1);
  arduboy.print(TONE[index]);
  arduboy.display();
}

void loop() {
  if (!arduboy.nextFrame()) {
    return;
  }

  arduboy.pollButtons();
  drawDisplay();

  if (arduboy.justPressed(B_BUTTON)) {
    index = constrain(
      index + 1,
      0, TONE_COUNT - 1
    );
  }

  if (arduboy.justPressed(A_BUTTON)) {
    index = STARTING_INDEX;
  }
}
