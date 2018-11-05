import {memoise} from './lib/memoise';

const unary = x => {
    console.log(`Calculating raw with ${x}`);
    const result = x * (1 + x) / 2;
    console.log(`Result inside function ${result}`);
    return result;
};

console.log(`Calculating raw with 10`);
const res1 = unary(10);
console.log(`Result: ${res1}\n`);

console.log(`Creating memoised version\n`);
const memoised = memoise(unary);

console.log(`Calculating memoised with 10 (should log)`);
const res2 = memoised(10);
console.log(`Result: ${res2}\n`);

console.log(`Calculating memoised with 10 (again - should not log)`);
const res3 = memoised(10);
console.log(`Result: ${res3}\n`);

console.log(`Calculating memoised with 20 (should log)`);
const res4 = memoised(20);
console.log(`Result: ${res4}\n`);

console.log(`Calculating memoised with 20 (again - should not log)`);
const res5 = memoised(20);
console.log(`Result: ${res5}\n`);
