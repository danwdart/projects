export default (n, b = 10) => {
    let total = 0,
        ns = n.toString(b);
    for (let i = 0; i < ns.length; i++) {
        total += Math.pow(Number(ns.charAt(i)), 2);
    }
    return total;
};
