export const add = f => g => () => f() + g();
export const mul = f => g => () => f() * g();
export const recip = f => () => 1 / f();