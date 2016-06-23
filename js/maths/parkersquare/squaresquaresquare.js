let min = 1,
    max = 10,
    loop = (what) => {
        for (let i = min; i <= max; i++) {
            what(i);
        }
    },
    different = (...things) => {
        for (let i = 0; i < things.length; i++) {
            let thing1 = things[i];
            for (let j = 0; j < i; j++) {
                let thing2 = things[j];
                if (thing1 == thing2) return false;
            }
        }
        return true;
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
            different(a,b,c,d,e,f,g,h,i)
        )
            console.log(a,b,c,d,e,f,g,h,i);
    }
)))))))));
