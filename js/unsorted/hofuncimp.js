const monad = x => {
    const ret = () => x;
    ret.toString = () => `[Monad ${x}]`;
    ret.map = fn => monad(fn(x));
    return ret;
};

const moreComplexMonad = x => {
    const ret = () => [x];
    ret.toString = () => `[Monad [${x}]]`;
    ret.map = fn => moreComplexMonad(fn(x));
    return ret;
};

const lazyMonad = (x, fns = []) => {
    const ret = () => x;
    ret.toString = () => `[Lazy ${x}, fns: [${fns}]]`;
    ret.map = fn => lazyMonad(x, [...fns, fn]);
    ret.unwrap = () => fns.reduce((x, fn) => fn(x), x);
    return ret;
};

// Does it implement Fn.map?
const map = x => fn => x.map ? x.map(fn) : x;
const unwrap = x => x.unwrap ? x.unwrap() : x;

const x = monad(3);
const y = map(x)(a => a + 1);

console.log(`My value is ${x} and its mapped value is ${y}`);

const x2 = moreComplexMonad(3);
const y2 = map(x2)(a => a + 1);

console.log(`My value is ${x2} and its mapped value is ${y2}`);

const lazyX = lazyMonad(3);
const lazyY = map(lazyX)(a => a + 1);
const lazyZ = map(lazyY)(a => a * 2);

console.log(`My value is ${lazyX} and its mapped value is ${lazyY} and its mapped value is ${lazyZ}`);
console.log(`lazyX unwraps to ${unwrap(lazyX)} and lazyY unwraps to ${unwrap(lazyY)} and lazyZ unwraps to ${unwrap(lazyZ)}`);
