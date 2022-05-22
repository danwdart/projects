import {data, io, fn, add} from "./libhaskell.hs";

console.log("Data: ", data());
io();
console.log("Result: ", add(2));
console.log("Stuff: ", fn("hi"));