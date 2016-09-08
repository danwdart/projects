let prime = function*() {
    let primes = [];
    yield 2;

    let prime = 3;
    checker:
    while (true) {
        for (let i = 0; i < primes.length; i++) {
            let tester = primes[i];
            //console.log('testing', tester, 'against', prime);
            if (0 == prime % tester) {
                prime += 2;
                continue checker;
            }
        }
        primes.push(prime);
        yield prime;
        prime += 2;
    }
};

let pb = (n) => {
    console.log('Checking pb of', n)
    let primes = prime();
    let mappy = new Map();
    while(1 < n) {
        let p = primes.next().value;
        mappy.set(p, 0);
        if (0 == n % p) {
            console.log('Adding', p)
            mappy.set(p, mappy.get(p) + 1);
            n /= p;
            console.log('n now', n)
        }
    }
    return mappy;
}

for (let i = 1; i <= 1000; i++) {
    console.log(i, 'is in prime base: '+JSON.stringify(pb(i)));
}
