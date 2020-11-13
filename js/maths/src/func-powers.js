const compose = f => g => x => f(g(x));
const power = fn => n => x => (n === 1) ? fn(x) : fn(power(fn)(n-1)(x));
const addOne = n => n + 1;

const plus = power(addOne);
const mul = compose(power)(plus);
const pow = compose(power)(mul);

console.log(plus(5)(3)) // 8
console.log(mul(5)(5)(0)); // 25'