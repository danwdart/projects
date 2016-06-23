for (var i = 1; i <= 1000000000000; i++) {
    var si = Math.pow(i, 1/3).toString(),
        sil = Math.floor(si).toString().length,
        sistr = si.replace(/\./, ''),
        pos =  sistr.indexOf(i);
    if (-1 !== pos && sil > pos) {
        console.log('Found ' + i + ' at position '+ pos + ' on ' + si);
    }
} 
