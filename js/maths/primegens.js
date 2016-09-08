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
},
primes = prime();

for (prime of primes) {
    console.log(prime);
}
