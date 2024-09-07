#include <ArduboyTones.h>

ArduboyTones arduboyTones(arduboy.audio.enabled);

const uint16_t SUCCESS_TONES[] PROGMEM = {
    NOTE_G3, 17, NOTE_C4, 34, NOTE_E4, 34, NOTE_C5, 68, TONES_END};
const uint16_t SUCCESS_TONES_LENGTH = 153;

const uint16_t LOSE_TONES[] PROGMEM = {
    NOTE_G2, 136, NOTE_E2,  136, NOTE_B2, 136, NOTE_C2, 136, NOTE_G2, 136,
    NOTE_E2, 136, NOTE_B2,  136, NOTE_C2, 136, NOTE_G2, 136, NOTE_E2, 136,
    NOTE_B2, 136, NOTE_C2,  136, NOTE_G2, 136, NOTE_E2, 136, NOTE_B2, 136,
    NOTE_C2, 136, TONES_END};
const uint16_t LOSE_TONES_LENGTH = 136 * 16;

void playInterval(int16_t tone1, int16_t tone2, int8_t currentRound) {
  arduboyTones.tone(tone1, LAST_TONE_DURATION * pow(DIMINISH, currentRound),
                    tone2, CURRENT_TONE_DURATION * pow(DIMINISH, currentRound));
}

void playSuccessSound(int8_t currentRound) {
  for (uint8_t i = 0; i <= currentRound; i++) {
    arduboyTones.tones(SUCCESS_TONES);
    delay(SUCCESS_TONES_LENGTH);
  }
}

void playGameOverSound() {
  arduboyTones.tones(LOSE_TONES);
  delay(LOSE_TONES_LENGTH);
}