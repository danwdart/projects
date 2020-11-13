export const getContext = () => new (window.AudioContext || window.webkitAudioContext)();

export const playSound = (context, soundData) => {
    const buffer = context.createBuffer(soundData.length, soundData[0].length, 22050),
        source = context.createBufferSource();
    buffer.copyToChannel(soundData[0], 0);
    buffer.copyToChannel(soundData[1], 1);
    source.buffer = buffer;
    source.connect(context.destination);
    source.start(0);
    // note: on older systems, may have to use deprecated noteOn(time);
};