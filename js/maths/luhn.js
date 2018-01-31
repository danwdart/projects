let luhn = (n) => {
    let sn = String(n),
        len = sn.length,
        rt = 0;
    for (let i = 0; i < len; i++) {
        let ni = sn.charAt(i),
            iie = 0 == i % 2,
            nni = Number(ni),
            realtot = (iie)?nni:(2*nni % 9);
        rt += realtot;
    }
    return ((9 * rt) % 10);
};
let b = 100201;
for (let i = 1; i <= 20; i++) {
    console.log(`On iteration`, i, `b =`, b, `and l =`, luhn(b));
    b = Number(String(b) + String(luhn(b)));
}
console.log(b);
console.log(luhn(444433332222111));
