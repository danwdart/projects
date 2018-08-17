
function direct() {
    "use strict";
    return (function f(n){
        if (n <= 0) {
            return  `foo`;
        }
        return f(n - 1);
    }(1e6)) === `foo`;
}

function mutual() {
    "use strict";
    function f(n){
        if (n <= 0) {
            return  `foo`;
        }
        return g(n - 1);
    }
    function g(n){
        if (n <= 0) {
            return  `bar`;
        }
        return f(n - 1);
    }
    return f(1e6) === `foo` && f(1e6+1) === `bar`;
}

console.log(direct());
console.log(mutual());

