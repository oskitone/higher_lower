#include <Arduboy2.h>
#include <ArduboyTones.h>

# define MIN_TONE               20
# define MAX_TONE               20000

# define LAST_TONE_DURATION     400
# define CURRENT_TONE_DURATION  (LAST_TONE_DURATION / 2)

// TODO: increase
# define TONES_COUNT            10

// NOTE: Yes, we start at 1 instead of 0,
// because we want an interval between tones.
// Ya can't diff off nuthin, charlie!
# define STARTING_INDEX         1

uint16_t tones[TONES_COUNT];
uint16_t index = STARTING_INDEX;

Arduboy2 arduboy;
ArduboyTones arduboyTones(arduboy.audio.enabled);

// TODO: decrease over time
int16_t getInterval() {
  return random(-1000, 1000 + 1);
}

void randomize() {
  tones[0] = random(MIN_TONE, MAX_TONE + 1);

  for (uint8_t i = 1; i < TONES_COUNT; i++) {
    // TODO: ensure w/in min/max range
    tones[i] = tones[i - 1] + getInterval();
  }
}

void playInterval() {
  arduboyTones.tone(
    tones[index - 1], LAST_TONE_DURATION,
    tones[index], CURRENT_TONE_DURATION
  );
}

void reset() {
  index = STARTING_INDEX;
  randomize();
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
  arduboy.print(tones[index - 1]);

  arduboy.setCursor(2, 4 + (7 + 1) * 2);
  arduboy.print(tones[index]);

  arduboy.display();
}

void increment() {
  index = constrain(
    index + 1,
    0, TONES_COUNT - 1
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
