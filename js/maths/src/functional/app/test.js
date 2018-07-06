let ia = f => x => y => z => f(f(x)(y))(z);
ia = f => x => y => z => f(x)(f(y)(z));
ia = f => x => y => f(f(x)(y));
const sum = x => y => x + y;
const main = () => ia(sum)(1)(2)(3);
console.log(main());
