const a = {
    a: 1,
    sayHi(p) {
        console.log(this, p);
    }
},
b = (p) => {
    console.log(this.a, p);
}

setImmediate(a::b);
setImmediate(::a.sayHi);
setImmediate(() => a::b(1));
setImmediate(() => ::a.sayHi(1));

const forEach = Array.prototype.forEach;
[0]::forEach(a => console.log(a))
