// yes I know it's suboptimal
let factor = (n) => {
        let factors = [],
            sn = n/2;
        for (let i = 1; i <= sn; i++) {
            if (0 == n % i) factors.push(i);
        }
        return factors;
    },
    sumarray = (arr) => arr.reduce((p,c)=>p+c, 0);
for (let i = 1; i <= 20000000; i++) {
    let sf = sumarray(factor(i));
    //console.log(i, sf, sf > i ? 'SUPER' : '', i == sf ? 'MATCHES' : '')
    if (sf == i + 3) console.log(i);
}
