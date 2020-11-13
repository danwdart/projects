export const constant = x => () => x;
export const compose = f => g => x => f(g(x));
export const flip = f => y => x => f(x)(y);
export const on = f => g => x => y => f(g(x))(g(y));
export const ap = f => g => x => f(x)(g(x));