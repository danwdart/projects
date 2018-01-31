"use strict";
function bnot(n)
{
    return n.toString(2)
        .replace(`1`,`2`)
        .replace(`0`,`1`)
        .replace(`2`,`0`);
}

function iter(n)
{
    return n << n.toString(2).length | bnot(n);
}

let begin = 1;
for (let i = 0; i <= 20; i++) {
    console.log(begin);
    begin = iter(begin);
}
