const power = 1 / Number(process.argv[2]),
    base = Number(process.argv[3]);

for (let i = 1; i <= 1e12; i++) {
    const si = Math.pow(i, power).toString(base),
        sil = Math.floor(si).toString(base).length,
        sistr = si.replace(/\./, ``),
        pos = sistr.indexOf(i);
    if (-1 !== pos && sil > pos) {
        console.log(`Found ` + i.toString(base) + ` at position `+ pos + ` on ` + si);
    }
}