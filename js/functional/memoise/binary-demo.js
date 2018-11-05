import {binaryMemoise} from './lib/memoise';

const binary = x =>  {
    console.log(`Calculating raw with ${x}`);
    return y => {
        console.log(`Calculating raw with ${y}`);
        const result = y * x;
        console.log(`Result inside function ${result}`);
        return result;
    }
};

console.log(`Calculating raw with 10, 20`);
const res1 = binary(10)(20);
console.log(`Result: ${res1}\n`);

console.log(`Creating memoised version\n`);
const memoised = binaryMemoise(binary);

console.log(`Calculating memoised with 10, 20 (should log)`);
const res2 = memoised(10)(20);
console.log(`Result: ${res2}\n`);

console.log(`Calculating memoised with 10, 20 (again - should not log)`);
const res3 = memoised(10)(20);
console.log(`Result: ${res3}\n`);

console.log(`Calculating memoised with 20, 30 (should log)`);
const res4 = memoised(20)(30);
console.log(`Result: ${res4}\n`);

console.log(`Calculating memoised with 20, 30 (again - should not log)`);
const res5 = memoised(20)(30);
console.log(`Result: ${res5}\n`);
