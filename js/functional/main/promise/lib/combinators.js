// In order to avoid duplication like x => x[y](z), we will introduce a new function.
export const combine = f => g => x => f(g(x));
export const apply = f => x => f(x);
export const applyTo = x => f => f(x);
export const identity = x => x;
export const constant = x => () => x;