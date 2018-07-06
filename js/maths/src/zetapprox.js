const iff = x => y => z => x ? y : z,
    eq = x => y => x === y,
    eq1 = eq(1),
    mod = x => y => x % y,
    gcd2 = x => y => y ? gcd2(y)(mod(x)(y)) : x,
    sum = a => a.reduce((t, n) => t + n),
    arrayFill = num => Array(num).fill(),
    div = f => g => f / g,
    I = x => x,
    K = x => () => x,
    mul = x => y => x * y,
    B = f => g => x => f(g(x)),
    ceilMul = x => y => Math.ceil(mul(x)(y)),
    map = f => x => x.map(f),
    // Eldritch abomination
    zeta2 = trials => faces => randomFn => B(div)(sum)(B(B)(map)(B(cmf => (() => B(iff)(eq1)(B(B(gcd2)(cmf)(randomFn()))(cmf)(randomFn()))(1)(0)))(ceilMul)(faces))(arrayFill)(trials))(trials);

const result = zeta2(500)(120)(Math.random);

console.log(zeta2(1)(1)(() => 1));

console.log(result);
console.log(Math.sqrt(div(6)(result)));