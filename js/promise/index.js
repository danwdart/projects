(function() {
    "use strict";

    var lib = require(`./promise`),
        Promise = lib.Promise,
        // Example
        // Here we will pretend that we're AJAX :P
        Ajax = function(url) {
            var promise = new Promise();
            this.then = function(success, error) {
                promise.then(success, error);
            };
            setTimeout(function() {
                if (0.5 > Math.random()) {
                    promise.reject(`Nope.`);
                } else {
                    promise.fulfil(`Some data.`);
                }
            });
        };
    var helloIWantSomeDataPlease = new Ajax(`myURL`);
    helloIWantSomeDataPlease
        .then(function(value) {
            console.log(`It worked! `+value);
        }, function(reason) {
            console.log(`It failed! `+reason);
        })
        .then(function(value) {
            console.log(`It worked again! `+value);
        }, function(reason) {
            console.log(`It failed again! `+reason);
        });
})();