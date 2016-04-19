let min = 1,
    max = 15,
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
        let tot = a**2+b**2+c**2;
        if (tot == d**2+e**2+f**2 &&
            tot == g**2+h**2+i**2 &&
            tot == a**2+d**2+g**2 &&
            tot == b**2+e**2+h**2 &&
            tot == c**2+f**2+i**2 &&
            tot == a**2+e**2+i**2 &&
            tot == c**2+e**2+g**2
        )
            console.log(a,b,c,d,e,f,g,h,i);
    }
)))))))));
