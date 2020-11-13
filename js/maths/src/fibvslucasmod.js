
let bases = [],
    Fs = [],
    Ls = [],
    agrees = [],
    baselimit = 2000;

for (let base = 2; base <= baselimit; base++) {
    let fibs = [1 % base,1 % base],
        lucas = [2 % base,1 % base],
        repeatingf = false,
        repeatingl = false;
    while (!repeatingf) {
        fibs.push((fibs[fibs.length - 2] + fibs[fibs.length - 1]) % base);

        if (1 == fibs[fibs.length - 2] &&
            0 == fibs[fibs.length - 1])
            repeatingf = true;
    }
    while (!repeatingl) {
        lucas.push((lucas[lucas.length - 2] + lucas[lucas.length - 1]) % base);

        if ((lucas[0] == (lucas[lucas.length - 2] + lucas[lucas.length - 1]) % base) &&
            (lucas[1] == (lucas[lucas.length - 2] + 2 *lucas[lucas.length - 1]) % base))
            repeatingl = true;
    }
    Fs[base] = fibs.length;
    Ls[base] = lucas.length;

    if (fibs.length != lucas.length)
        bases.push(base);
    //console.log('F', fibs.join(','), 'L:', lucas.join(','));
}

for (let i = 1; i <= baselimit/5; i++) {
    if (!bases.includes(i * 5)) {
        agrees.push(Fs[i * 5]);
    }
}
console.log(agrees.join(`,`));
