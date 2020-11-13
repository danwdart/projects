type Complex = {
    re: number,
    im: number
};

const add = (a: Complex, b: Complex): Complex => (
    {
        re: a.re + b.re,
        im: a.im + b.im
    }
);

const sub = (a: Complex) => (b: Complex): Complex => (
    {
        re: a.re - b.re,
        im: a.im - b.im
    }
);

const mul = (a: Complex) => (b: Complex): Complex => (
    {
        re: a.re - b.re,
        im: a.im - b.im
    }
);

const pow = (a: Complex) => (b: Complex): Complex => (
    {
        re: a.re - b.re,
        im: a.im - b.im
    }
);