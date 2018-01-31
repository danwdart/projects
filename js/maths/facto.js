const to = 100,
    res = {};

for (let i = 0; i < to; i++) {
    for (let j = 0; j < to; j++) {
        ans = (i * j) % to;
        res[ans] = res[ans] || [];
        res[ans].push([i,j]);
    }
}

//console.log(res);

for (let n in res) {
    console.log(`${res[n].length} ways to get to ${n}`);
}

/*
const a = 17,
    b = 19,
    c = a * b;
let max = 1;

for (let i = 2; i < a/2; i++) {
    const mod = a % i;
    console.log(`${a} = ${mod} mod ${i}`);
    max = Math.max(max, i);
}

for (let i = 2; i < b/2; i++) {
    const mod = b % i;
    console.log(`${b} = ${mod} mod ${i}`);
    max = Math.max(max, i);
}

for (let i = 2; i <= max; i++) {
    const mod = c % i;
    console.log(`${c} = ${mod} mod ${i}`);
}
*/
