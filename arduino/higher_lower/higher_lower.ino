#include <Arduboy2.h>
#include <ArduboyTones.h>

# define MIN_TONE               20
# define MAX_TONE               20000

# define LAST_TONE_DURATION     1000
# define CURRENT_TONE_DURATION  250

// TODO: increase
# define TONE_COUNT             10

// NOTE: Yes, we start at 1 instead of 0,
// because we want an interval between tones.
// Ya can't diff off nuthin, charlie!
# define STARTING_INDEX         1

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

void playInterval() {
  arduboyTones.tone(
    TONE[index - 1], LAST_TONE_DURATION,
    TONE[index], CURRENT_TONE_DURATION
  );
}

void reset() {
  index = STARTING_INDEX;
  playInterval();
}

void setup() {
  arduboy.beginDoFirst();
  arduboy.waitNoButtons();

  arduboy.setFrameRate(15);

  reset();
}

void drawDisplay() {
  arduboy.clear();

  arduboy.setCursor(2, 2);
  arduboy.print(index);

  arduboy.setCursor(2, 4 + (7 + 1) * 1);
  arduboy.print(TONE[index - 1]);

  arduboy.setCursor(2, 4 + (7 + 1) * 2);
  arduboy.print(TONE[index]);

  arduboy.display();
}

void increment() {
  index = constrain(
    index + 1,
    0, TONE_COUNT - 1
  );

  playInterval();
}

void loop() {
  if (!arduboy.nextFrame()) {
    return;
  }

  arduboy.pollButtons();
  drawDisplay();

  if (arduboy.justPressed(B_BUTTON)) {
    increment();
  }

  if (arduboy.justPressed(A_BUTTON)) {
    reset();
  }
}
