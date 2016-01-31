 function saa(n) { var ns = Math.pow(n,2), sn = String(ns), l = sn.length, fb = Number(sn.substring(0,l/2)), lb = Number(sn.substring(l/2,l)); return n == fb + lb; }
for (var i = 0; i < 10000000; i++) { if (saa(i)) console.log(i); }
