for (var i = 1; i <= 1000000000000; i++) {
    var si = Math.pow(i, 1/2).toString(2),
        sil = Math.floor(si).toString(2).length,
        sistr = si.replace(/\./, ``),
        pos =  sistr.indexOf(i.toString(2));
    if (-1 !== pos && sil > pos) {
        console.log(`Found ` + i.toString(2) + ` at position `+ pos + ` on ` + si);
    }
} 
