let min = 1,
    max = 10,
    loop = (what) => {
        for (let i = min; i <= max; i++) {
            what(i);
        }
    };

loop(
    (a) => loop(
    (b) => loop(
    (c) => loop(
    (d) => loop(
    (e) => loop(
    (f) => loop(
    (g) => loop(
    (h) => loop(
    (i) => {
        let tot = a+b+c;
        if (tot == d+e+f &&
            tot == g+h+i &&
            tot == a+d+g &&
            tot == b+e+h &&
            tot == c+f+i &&
            tot == a+e+i &&
            tot == c+e+g &&
            a != i &&
            c != g &&
            b != h &&
            d != f
        )
            console.log(a,b,c,d,e,f,g,h,i);
    }
)))))))));
