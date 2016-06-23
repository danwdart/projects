for (let mod = 2; mod < 36; mod++) {
    console.log('Mod '+mod);
    for (let y = 1; y <= mod - 1; y++) {
        let line = '';
        for (let x = 1; x <= mod - 1; x++) {
            line += ((x * y) % mod).toString(mod);
        }
        console.log(line);
    }
}
