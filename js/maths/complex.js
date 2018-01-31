class Complex
{
    constructor(re, im)
    {
        this.re = re;
        this.im = im;
    }

    [Symbol.toPrimitive]() {
        return `${this.re} + ${this.im}i`;
    }

    valueOf()
    {
        return this.re;
    }

    toString()
    {
        return this.im;
    }
}


const test = new Proxy(
    new Complex(1, 2),
    {
        get(on, what) {
            console.log(what);
            return on[what];
        }
    }
);

console.log(test + test * test + `hi`);
