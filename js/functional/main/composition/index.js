// B = Bluebird, 3, 1 -> 1 -> 0
const bluebird = f => g => x => f(g(x));
// 2B = D = Dove, 4, 2 -> 0 -> 1 -> 0
const dove = f => x => g => y => f(x)(g(y));
// 3B = B1 = Blackbird, 4, 1 -> 2 -> 0 -> 0
const blackbird = f => g => x => y => f(g(x)(y));
// 4B = D1 = Dickcissel, 5. 3 -> 0 -> 0 -> 1 -> 0
const dickcissel = f => x => y => g => z => f(x)(y)(g(z));
// 5B = B3 = Becard, 4, 1 -> 1 -> 1 -> 0
const becard = f => g => h => x => f(g(h(x)));
// 6B = D2 = Dovekies, 5, 2 -> 1 -> 0 -> 1 -> 0
const dovekies = f => g => x => h => y => f(g(x))(h(y));
// 7B = E = Eagle, 5, 2 -> 0 -> 2 -> 0 -> 0
const eagle = f => x => g => y => z => f(x)(g(y)(z));
// 8B = B2 = Bunting, 5, 1 -> 3 -> 0 -> 0 -> 0
const bunting = f => g => x => y => z => f(g(x)(y)(z));
// 7B(7B) = E(E) = Ê = Bald Eagle, 7, 2 -> 2 -> 0 -> 0 -> 2 -> 0 -> 0
const baldeagle = f => g => x => y => h => z => w => f(g(x)(y))(h(z)(w));

const trinary = a => b => c => a + b + c;
const binary = trinary(3);
const unary = binary(2);
const value = 1;

const _2B = bluebird(bluebird);
const _3B = _2B(bluebird);
const _4B = _3B(bluebird);
const _5B = _4B(bluebird);
const _6B = _5B(bluebird);
const _7B = _6B(bluebird);
const _8B = _7B(bluebird);

const B_2 = bluebird(bluebird);
const B_3 = bluebird(B_2);
const B_4 = bluebird(B_3);

//it appears B(BB)(BB)(BBBB) ==== B(BB)(BB)(BBBBBBBB) ?

/*
Anyway...
B^2 = 2B
B^3 = 4B
B^4 = ?

B(2B) = 4B
B(3B) = 7B

2B(B) = 3B obviously
2B(2B) = 6B
2B(3B) = 10B - although possibly.... fewer Bs

3B(B) = 4B obviously
3B(2B) = 9B... perhaps
*/

console.log([
    [
        B_4
    ],
    [
        bluebird(unary)(unary)(value),
    ],
    [
        _2B(binary)(value)(unary)(value),
        B_2(binary)(value)(unary)(value),
        dove(binary)(value)(unary)(value)
    ],
    [
        _3B(unary)(binary)(value)(value),
        blackbird(unary)(binary)(value)(value)
    ],
    [
        _4B(trinary)(value)(value)(unary)(value),
        B_3(trinary)(value)(value)(unary)(value),
        dickcissel(trinary)(value)(value)(unary)(value)
    ],
    [
        _5B(unary)(unary)(unary)(value),
        becard(unary)(unary)(unary)(value)
    ],
    [
        _6B(binary)(unary)(value)(unary)(value),
        _2B(_2B)(binary)(unary)(value)(unary)(value),
        dovekies(binary)(unary)(value)(unary)(value)
    ],
    [
        _7B(binary)(value)(binary)(value)(value),
        bluebird(_3B)(binary)(value)(binary)(value)(value),
        eagle(binary)(value)(binary)(value)(value)
    ],
    [
        _8B(unary)(trinary)(value)(value)(value),
        bunting(unary)(trinary)(value)(value)(value)
    ],
    [
        _7B(_7B)(binary)(binary)(value)(value)(binary)(value)(value),
        baldeagle(binary)(binary)(value)(value)(binary)(value)(value)
    ]
]);

/*
B(B) = B^2 = B2
B(B(B)) = B(B2) = B^3 = B4
B(B(B(B))) = B^4 = B(B^3) = B(B4) = B8

???
B(B(B(B(B)))) = B^5 = B(B^4) = B(B8) = B16
???

B^x = B((x-1)^2)
*/