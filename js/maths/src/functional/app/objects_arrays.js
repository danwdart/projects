import { B } from './combinators';
export const get = x => y => y[x];
export const map = f => x => x.map(f);
export const reduce = f => x => y => y.reduce((z, w) => f(z)(w), x);
export const filter = f => x => x.filter(f);
export const arrayOf = (x) => (y) => Array.apply(null, Array(y)).map(() => x);
export const pluck = B(map)(get);
