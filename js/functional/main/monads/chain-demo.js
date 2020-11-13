import {chain, lazyChain} from './lib/chain';

const addTwo = x => { console.log('Adding two'); return x + 2;};
const mulThree = x => { console.log('Multiplying by three'); return x * 3;};

console.log('Chain Maps\n');

console.log('\nRegular Chain\n');
const c = chain(5).map(addTwo).map(mulThree);
console.log(`c = ${c}`);
const cVal = c.value;
console.log(`cVal = ${cVal}`);

console.log('\nLazy Chain\n');
const lC = lazyChain(5).map(addTwo).map(mulThree);
console.log(`lC = ${lC}`);
const lCVal = lC.value();
console.log(`lCVal = ${lCVal}`);