import * as R from './deps.ts';

console.log(R);

console.log(R.compose(x => x + 1, x => x * 2, x => x * 4)(1));