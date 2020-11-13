// Now objects

const Right = x => ({
    unwrap: () => x,
    map: f => Right(f(x))
});

const Left = x => ({
    unwrap: () => x,
    map: () => Left(x)
});

const either = cond => l => r => cond ? Right(r) : Left(l);

const addTwo = x => x + 2;

const a = either(1 == 2)('No')(1);
const b = a.map(addTwo);
console.log(b.unwrap());

const c = either(1 === 1)('No')(1);
const d = c.map(addTwo);
console.log(d.unwrap());