var n = Number(process.argv[2]);
console.log(n);
//for (var it = 1; it <= 10; it++) {
while (1 != n && 145 != n) {
	
    var sn = n.toString(),
        t = 0;
    for (var i in sn) {
        t += Math.pow(Number(sn[i]), 2);
    }
    n = Number(t);
    console.log(n);
}