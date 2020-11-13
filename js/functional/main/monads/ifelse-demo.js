const ifElse = x => y => z => x ? y : z;
const ifEquals = a => b => c => d => a === b ? c : d;

const output = ifElse(2 == 1)('yes')('no');
const out2 = ifEquals(2)(1)('yes')('no');

console.log(output, out2);