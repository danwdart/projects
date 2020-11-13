export const constant = x => () => x
export const compose = f => g => x => f(g(x))
export const applyTo = x => f => f(x);
export const flip = f => x => y => f(y)(x)