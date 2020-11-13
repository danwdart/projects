/*
1 2
0

2 2
010
101

3 2
l7 guess
0102120
0120210
0201210
0210120
0212010
1020121
1021201
1201021
1202101
1210201
2010212
2021012
2101202
2120102

4 2
l13 guess
0123021031320
*/

function conflict(num) {
    if (1 >= num.length) return false;
    for (var i = 0; i < num.length; i++) {
        var last = num.charAt(i),
            penul = num.charAt(i-1),
            together = penul+last;
        if (`` == penul) continue;
        //console.log({num:num, i:i,last:last,penul:penul,together:together});
        if (last == penul ||
        (-1 !== num.indexOf(together) &&
        (i-1) !== num.indexOf(together))) return true;
    }
    return false;
}

//ugh
for (var i = 0; i < 1000000; i++) {
    var num = i.toString(3);
    //console.log('testing', num);
    if (!conflict(num)) console.log(num);
}