let primecache = new Set();

function isprime(i) {
    if (1 == i) return false;
    for (let v of getprimefactors(i)) {
        return false;
    }
    return true;
}

function* getprimes(upto) {
    var lv = 2;
    for (let i of primecache) {
        lv = i;
        if (upto <= i) return;
        yield i;
    }
    if (2 >= lv) {
        primecache.add(2);
        yield 2;
        lv = 3;
    }
    for (let i = lv; i <= upto; i += 2) {
        if (isprime(i)) {
            primecache.add(i);
            yield i;
        }
    }
}

function *getprimefactors(i) {
    for (let v of getprimes(Math.sqrt(i))) {
        if (0 == i % v) {
            yield v;
            i /= v;
        }
        if (1 == i) return;
    }
}

let highestn = 1,
    highesti = 1;
for (let b = 2; b <= 10000; b++) {
    for (let c = 1; c < b; c++) {
        let n = b+c,
            nprimes = 0,
            ncomposites = 0;
        for (let i = 1; i <= 100000; i++) {
            if (isprime(n)) {
                //console.log(n);
                nprimes++;
            } else {
                //console.log(`\t${n}`);
                ncomposites++;
            }
            if (0.5 >= (nprimes/(nprimes + ncomposites))) {
                if (n > highestn) {
                    console.log(`HIGH n: ${b} mod ${c} starts to become more composite at its ${i}th term: ${n}`);
                    highestn = n;
                }
                if (i > highesti) {
                    console.log(`\tHIGH i: ${b} mod ${c} starts to become more composite at its ${i}th term: ${n}`);
                    highesti = i;
                }
                break;
            }
            n += b;
        }
    }
}
/*
 * HIGH n: 2 mod 1 starts to become more composite at its 46th term: 93
        HIGH i: 2 mod 1 starts to become more composite at its 46th term: 93
HIGH n: 4 mod 1 starts to become more composite at its 36th term: 145
HIGH n: 6 mod 1 starts to become more composite at its 160th term: 961
        HIGH i: 6 mod 1 starts to become more composite at its 160th term: 961
HIGH n: 6 mod 5 starts to become more composite at its 180th term: 1085
        HIGH i: 6 mod 5 starts to become more composite at its 180th term: 1085
HIGH n: 12 mod 1 starts to become more composite at its 126th term: 1513
HIGH n: 24 mod 1 starts to become more composite at its 66th term: 1585
HIGH n: 30 mod 1 starts to become more composite at its 172th term: 5161
HIGH n: 30 mod 13 starts to become more composite at its 196th term: 5893
        HIGH i: 30 mod 13 starts to become more composite at its 196th term: 5893
HIGH n: 30 mod 19 starts to become more composite at its 210th term: 6319
        HIGH i: 30 mod 19 starts to become more composite at its 210th term: 6319
HIGH n: 60 mod 49 starts to become more composite at its 154th term: 9289
HIGH n: 120 mod 1 starts to become more composite at its 92th term: 11041
HIGH n: 120 mod 49 starts to become more composite at its 96th term: 11569
HIGH n: 150 mod 121 starts to become more composite at its 86th term: 13021
HIGH n: 168 mod 25 starts to become more composite at its 84th term: 14137
HIGH n: 210 mod 1 starts to become more composite at its 80th term: 16801
HIGH n: 210 mod 79 starts to become more composite at its 92th term: 19399
HIGH n: 210 mod 121 starts to become more composite at its 148th term: 31201
HIGH n: 210 mod 173 starts to become more composite at its 168th term: 35453
HIGH n: 420 mod 121 starts to become more composite at its 100th term: 42121
HIGH n: 630 mod 541 starts to become more composite at its 96th term: 61021
HIGH n: 840 mod 1 starts to become more composite at its 74th term: 62161
HIGH n: 840 mod 529 starts to become more composite at its 78th term: 66049
HIGH n: 1050 mod 571 starts to become more composite at its 122th term: 128671
HIGH n: 1680 mod 121 starts to become more composite at its 78th term: 131161
HIGH n: 2310 mod 493 starts to become more composite at its 58th term: 134473
HIGH n: 2310 mod 499 starts to become more composite at its 60th term: 139099
HIGH n: 2310 mod 551 starts to become more composite at its 66th term: 153011
HIGH n: 2310 mod 607 starts to become more composite at its 70th term: 162307
HIGH n: 2310 mod 1237 starts to become more composite at its 92th term: 213757
HIGH n: 2730 mod 751 starts to become more composite at its 96th term: 262831
HIGH n: 4200 mod 841 starts to become more composite at its 70th term: 294841
HIGH n: 4290 mod 2279 starts to become more composite at its 72th term: 311159
HIGH n: 4620 mod 1471 starts to become more composite at its 86th term: 398791
HIGH n: 5460 mod 3481 starts to become more composite at its 76th term: 418441
HIGH n: 5460 mod 3977 starts to become more composite at its 84th term: 462617
HIGH n: 6510 mod 3629 starts to become more composite at its 96th term: 628589
 */
