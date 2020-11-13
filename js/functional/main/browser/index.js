const IO = io => ({
    performUnsafeIO: io,
    map: f => IO(() => f(io())),
    flatMap: f => IO(() => Array.from(io()).map(f))
});

const main = IO(() => document.querySelectorAll('script'))
    .flatMap(x => `Name: ${x.src}`)
    .map(a => a.join(''))
    .map(console.log);

main.performUnsafeIO();