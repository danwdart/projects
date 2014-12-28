// Tests prime tests and finds what the best is.

var upto=100000;

function testPrime_1(n) {
    for (var i = 2; i<=n; i++) {
        if (0 == n % i) return false;
    }
    return true;
}

function testPrime_2(n) {
    var sn = Math.floor(Math.sqrt(n));
    for (var i = 2; i<=sn; i++) {
        if (0 == n % i) return false;
    }   
    return true;
}

var f = [];
function factorial (n) {
    if (n == 0 || n == 1)
        return 1;
    if (f[n] > 0)
        return f[n];
    return f[n] = factorial(n-1) * n;
}

function testPrime_3(n) {
    var fnm = factorial(n-1) + 1;
    return 0 == fnm % n;
}

start1 = (new Date()).getTime();
for (var j = 2; j <= upto; j++) {
    var ans = testPrime_1(j);
    //console.log(j+' is'+((ans)?' ':' NOT ')+'prime.');
}
end1 = (new Date()).getTime();


start2 = (new Date()).getTime();
for (var j = 2; j <= upto; j++) {
    var ans = testPrime_2(j);
    //console.log(j+' is'+(ans?' ':' NOT ')+'prime.');
}
end2 = (new Date()).getTime();

//start3 = (new Date()).getTime();
//for (var j = 2; j <= upto; j++) {
//    console.log(j+' is'+((testPrime_3(j))?' ':' NOT ')+'prime.');
//}
//end3 = (new Date()).getTime();

console.log('Method 1: '+(end1 - start1)+' ms.');
console.log('Method 2: '+(end2 - start2)+' ms.');
//console.log('Method 3: '+(end3 - start3)+' ms.');
