let min = 1,
    max = 15,
    loop = (to, what) => {
        for (let i = min; i <= max; i++) {
            if (different(...to, i))
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

loop([],
    (a) => loop([a],
        (b) => { console.log(a,b); loop([a,b],
            (c) => loop([a,b,c],
                (d) => loop([a,b,c,d],
                    (e) => loop([a,b,c,d,e],
                        (f) => loop([a,b,c,d,e,f],
                            (g) => loop([a,b,c,d,e,f,g],
                                (h) => loop([a,b,c,d,e,f,g,h],
                                    (i) => {
                                        let tot = a**2+b**2+c**2;
                                        if (tot == d**2+e**2+f**2 &&
            tot == g**2+h**2+i**2 &&
            tot == a**2+d**2+g**2 &&
            tot == b**2+e**2+h**2 &&
            tot == c**2+f**2+i**2 &&
            tot == a**2+e**2+i**2 &&
            tot == c**2+e**2+g**2 &&
            different(a,b,c,d,e,f,g,h,i)
                                        )
                                            console.log(a,b,c,d,e,f,g,h,i);
                                    }
                                )))))));}));
