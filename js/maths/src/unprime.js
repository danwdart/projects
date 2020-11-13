/*

*/

let c = Number(process.argv[2]);
console.log(`Attempting to deconstruct ${c}`);

let t = c;

for (let i = 3; i <= t; i+=2) {
    console.log(`primesearch`, t, i, t % i);
}
