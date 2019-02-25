const later = x => () => x;
const unwrap = l => l();
const map = l => f => later(f(unwrap(l)));
//const ap = lv => lf => map(lv)(unwrap(lf));

const ap = lv => lf => later(unwrap(lf)(unwrap(lv)));


const a = later(1);
const f = x => x + 1;
console.log(unwrap(map(a)(f)));
console.log(unwrap(ap(a)(later(f))));

const MyIO = f => ({
    unwrap: f,
    map: g => MyIO(() => g(f())),
    ap: g => MyIO(() => g.unwrap()(f()))
});

const b = MyIO(() => 1);
const g = x => x + 2;
const gio = MyIO(() => g);
console.log(b.map(g).unwrap());
console.log(b.ap(gio).unwrap());
