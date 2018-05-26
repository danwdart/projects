for (let base = 2; base <= 36; base++) {
    for (let power = 2; power <= base; power++) {
        let str = ``;
        for (let n = 1; n < base; n++) {
            str += (Math.pow(n, power) % base).toString(base);
        }
        console.log(`Power `+power+` mod `+base+`: `+str);
    }
}
