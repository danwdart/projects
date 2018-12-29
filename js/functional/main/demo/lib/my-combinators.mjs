export const foo = f => g => x => y => f(g(x)(y))
export const exec = x => x()