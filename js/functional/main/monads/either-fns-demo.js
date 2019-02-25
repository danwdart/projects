// Functions only

const makeRight = x => (x => {
    const Right = () => x;
    return Right;
})(x);

const makeLeft = x => ((x) => {
    const Left = () => x;
    return Left;
})(x);

const either = cond => l => r => cond ? makeRight(r) : makeLeft(l);

const mapEither = e => f => ({
    Right: () => f(e()),
    Left: () => e()
}[e.name]);

const addTwo = x => x + 2;

const a = either(1 == 2)('No')(1);
const b = mapEither(a)(addTwo);
console.log(b());

const c = either(1 === 1)('No')(1);
const d = mapEither(c)(addTwo);
console.log(d());