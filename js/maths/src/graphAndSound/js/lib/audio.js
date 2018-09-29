export const getContext = () => new (window.AudioContext || window.webkitAudioContext)();
export const getBuffer = context => context.createBuffer(2, 100000, 22050);
export const getChannels = buffer => ([buffer.getChannelData(0), buffer.getChannelData(1)]);

export function playSound(context, buffer) {
    var source = context.createBufferSource(); // creates a sound source
    source.buffer = buffer;                    // tell the source which sound to play
    source.connect(context.destination);       // connect the source to the context's destination (the speakers)
    source.start(0);                           // play the source now
    // note: on older systems, may have to use deprecated noteOn(time);
}

export const startsound = (...args) => setTimeout(playSound.bind(null, ...args), 5000);
