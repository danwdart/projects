for (var i = 1; i <= 1000000000000; i++) {
    var si = Math.pow(i, 1/2).toString(16),
        sil = Math.floor(si).toString(16).length,
        sistr = si.replace(/\./, ''),
        pos =  sistr.indexOf(i.toString(16));
    if (-1 !== pos && sil > pos) {
        console.log('Found ' + i.toString(16) + ' at position '+ pos + ' on ' + si);
    }
} 
