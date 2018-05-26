export function startsound(context, buffer) {
    setTimeout(function() {
        var source = context.createBufferSource();
        source.buffer = buffer;
        source.connect(context.destination);
        source.start(0);
    },
    5000);
}