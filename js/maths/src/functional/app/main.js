import { B } from './combinators';
import { arrayOf } from './objects_arrays';
const sum = (arr) => arr.reduce((t, n) => t + n), arrayOfBlanks = arrayOf(0), zeta = arrayOfBlanks(500).map(() => arrayOfBlanks(3).map(() => Math.ceil(6 * Math.random()))).map(sum);
export const main = B(B)(B)(console.log)(zeta);
