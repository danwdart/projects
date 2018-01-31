"use strict";
import BN from 'bignumber.js';
BN.config(10000,4);
function flt(using, what)
{
    using = new BN(using);
    what = new BN(what);
    let inter = using.pow(what).minus(using);
    return inter.dividedBy(what).floor( ).times(what).equals(inter);
}
for (var i = 0; i <= 1000; i++) {
    if (flt(2, i))
        console.log(i, `is prime.`);
    else
        console.log(i, `is not prime.`);
}