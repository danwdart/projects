const zeroToN = n => Object.keys(Array(n).fill()).map(Number);
const compose = f => g => x => f(g(x));
const flat = a => [].concat(...a);
const join = s => a => a.join(s);
const a = f => n => m => `${n} by ${m} = ${f(m)(n)}`
const map = a => f => a.map(f);

const add = x => y => x + y;
const mul = x => y => x * y;

const moonAdd = x => y => Math.max(x, y);
const moonMul = x => y => Math.min(x, y);

const zeroToTen = zeroToN(10);
const joinWithNL = join(`\n`);
const arrayToTableGenerator = compose(compose(compose(joinWithNL)(flat)))
const DCMZT = compose(compose(map(zeroToTen)));
const output = DCMZT(DCMZT);
const table = arrayToTableGenerator(output)
const tableFormatted = table(a);

console.log(`Regular arithmetic`)
console.log(tableFormatted(mul));

console.log(`Lunar arithmetic`)
console.log(tableFormatted(moonMul));