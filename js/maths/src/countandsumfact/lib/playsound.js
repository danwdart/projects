export function playSound(context, buffer) {
    var source = context.createBufferSource(); // creates a sound source
    source.buffer = buffer;                    // tell the source which sound to play
    source.connect(context.destination);       // connect the source to the context's destination (the speakers)
    source.start(0);                           // play the source now
    // note: on older systems, may have to use deprecated noteOn(time);
}

export function playTone(context, freq, time, delay) {
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
