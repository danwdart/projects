export const calc = options => {
    const lines = [],
        tones = [],
        channels = [
            new Float32Array(options.numbers),
            new Float32Array(options.numbers)
        ];

    let oldx = 0,
        oldy = 0;

    for (let i = 0; i < options.numbers; i++) {
        let sf = options.fn(i, oldx, oldy),
            newx = i,
            newy = options.newyfn(sf);
        //if (newy == newx) continue;
        //if (newy > Math.sqrt(newx)) continue;
        lines.push(
            [
                oldx * options.scale.x, oldy * options.scale.y,
                newx * options.scale.x, newy * options.scale.y
            ]
        );

        tones.push(options.tonefn(i, newx, newy));

        oldx = newx;
        //if (1 != newy) {
        oldy = newy;

        channels[0][i] = options.soundfn(newy);
        channels[1][i] = options.soundfn(newy);
    }

    return [lines, tones, channels];
};