"use strict";
function flt(using, what)
{
    let inter = using ** what - using;
    return 0n === inter % what;
}
for (var i = 1n; i <= 1000n; i++) {
    console.log(`${i} is${flt(2n, i) ? `` : ` not`} prime.`);
}
