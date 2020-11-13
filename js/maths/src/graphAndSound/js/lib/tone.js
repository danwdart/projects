function playTone(context, freq, time, delay) {
    var oscillator = context.createOscillator();
    oscillator.type = 0; // sine wave

    setTimeout(function() {
        oscillator.frequency.value = freq;
        oscillator.connect(context.destination);
        oscillator.start();
    }, delay);

    setTimeout(function() {
        oscillator.stop();
    }, delay + time);
}

export const playTones = (context, tones) => tones.forEach(
    toneData => playTone(context, ...toneData)
);