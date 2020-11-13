First = (function() {
    var First = function() {
        var self = this,
            _priv = function() {
                console.log(`private function`);
            };

        // Public!! Only private when constructor returns an object
        this._ppriv = function() {
            console.log(`semiprotected function`);
            _priv();
        };

        console.log(`I am a constructor. If I am called without new then this will be the global object`);
        //console.log(this);

        // If your constructor returns an object then you can't append extra functions
        // and the non-included functions get protected / private
        /*
		return {
			pub: function() {
				self._ppriv();
				console.log('public function: this refers to the public part');
				console.log(this);
				console.log('self refers to the inside-scope bit (global if not new-d');
				//console.log(self);
				console.log('we can even show _priv if we refer to it by name');
				console.log(_priv);
			}
		}
		*/
    };

    // Publics - defined after
    First.prototype.PubProto = function() {
        console.log(`this refers to the semi protected part, the things that went into "this" earlier;`);
        console.log(this);
        console.log(`However we cannot refer to the private part here`);
        this._ppriv();
    };

    // Statics
    First.makeMeAnA = function() {
        return new a();
    };

    return First;
})();

a = new First();
a.PubProto();
console.log(`The properties of a are:`);
console.log(a);
console.log(`the properties of First are:`);
console.log(First);
console.log();
console.log(`To stir things up we will call without the new keyword...`);
console.log();
//b = First();
//b.pub();

console.log();
console.log(`Let's attempt to extend the class now.`);

// Object.create(new First())
Second = function() {
    console.log(`constructor calling superconstructor. Let us be avin ya.`);
    this.secondProtFunc = function() { console.log(this);};
    // this is like Super.construct
    First.call(this);
};
// inherit all of the prototypes.
for (i in First.prototype) { Second.prototype[i] = First.prototype[i];}
Second.prototype.sayHello = function() { console.log(`Hi!`);  };

c = new Second();


c.PubProto();
c.sayHello();
console.log(c);