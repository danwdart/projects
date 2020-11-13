/* eslint-disable */
var p = function(n) {
        var sn = Math.sqrt(n);
        for (var i = 2; i <= sn; i++) {
            if (0 == n % i) {
                return false;
            }
        }
        return true;
    },
    f = function(n) {
        var sn = n/2,
            aF = [];
        for (var i = 1; i <= sn; i++) {
            if (n % i == 0) {
                aF.push(i);
            }
        }
        aF.push(n);
        return aF;
    },
    ft = function(n) {
        var t = 0,
            sn = n/2;
        for (var i = 1; i <= sn; i++) {
            if (n % i == 0) {
                t += i;
            }
        }
        return t;
    },
    perf = function(t) {
        p = [];
        for (var i = 1; i<= t; i++) {
            if (ft(i) == i) {
                p.push(i);
            }
        }
        return p;
    },
    am = function(t) {
        p = [];
        for (var i = 1; i<= t; i++) {
            Ft = ft(i);
            if (ft(Ft) == i && i != Ft) {
                p.push([i,Ft]);
            }
        }
        return p;
    },
    pf = function(n) {
        var t = n,
            aF = [];
        for (var i = 2; i <= n; i++) {
            if (p(i)) {
                while (n % i == 0) {
                    n /= i;
                    aF.push(i);
                    if (1 == n) {
                        return aF;
                    }
                }
            }
        }
    };
f(223);