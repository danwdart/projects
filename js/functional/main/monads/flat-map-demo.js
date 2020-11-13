const myMon = x => ({
    type: 'myMon',
    flat: () => (x.type && x.type == 'myMon') ? x : myMon(x),
    map: fn => myMon(fn(x)),
    flatMap: fn => (x.type && x.type == 'myMon') ? myMon(fn(x.unwrap())) : myMon(fn(x)),
    unwrap: () => x
});

const inc = x => x + 1;

const me = myMon(myMon(1).map(inc));

console.log(me.unwrap()); // oops, it's still a mon

const me2 = myMon(myMon(1)).flatMap(inc);

console.log(me2.unwrap()); // yay!

const me3 = myMon(myMon(1)).flat();
console.log(me3.unwrap());