let things = {},
    even = (n) => 0 == n % 2,
    iterate = (n) => even(n)?n/2:3*n+1,
    iterations = (n, m = 0) => (1 == n)?m:iterations(iterate(n), m)+1;
for (let i = 1; i < 1000; i++) {
    let it = iterations(i);
    if (`undefined` === typeof things[it])
        things[it] = []; 
    things[it].push(i);
}
for (let i in things) {
    console.log(i+`,`+things[i].length);
}
