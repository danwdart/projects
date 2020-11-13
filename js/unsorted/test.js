var itt = function() {
        var self = this;

        self._elems = [];

        self.add = function(e) {
            self._elems.push(e);
        };

        self.forEach = function(cb) {
            for (var i = 0; i < self._elems.length; i++) {
                cb(self._elems[i], i);
            }
        }; 
    },
    bob = new itt();

bob.add(`1`);
bob.add(`2`);
bob.add(`3`);
console.log(`hi`);
bob.forEach(function(e) {
    console.log(e);
});
console.log(`ho`);
