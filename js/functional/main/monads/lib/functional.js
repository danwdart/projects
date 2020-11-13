export const compose = f => g => x => f(g(x));
export const dup = f => x => f(x)(x);