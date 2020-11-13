import {
    blackbird
} from 'fantasy-birds';

console.log('beprs test');
const uc = s => s.toUpperCase();
const add = x => y => x + y;
const result = blackbird(uc)(add)("hello ")("world");
console.log(result);

// I don't really know if there's a point outside of
// other combinatorial stuff because this kinda is a no-op?
const anotherLogTbh = blackbird(console.log);

const logWhatsAdded = anotherLogTbh(add);
logWhatsAdded(2)(3);
