class B
{
    constructor()
    {
        this._a = friender(new A(), A.CLASSES);
        this._a.sayHi();
        this.doSomething();
    }

    doSomething()
    {
        this._a.doSomething();
    }
}

class C
{
    constructor()
    {
        this._a = friender(new A(), A.CLASSES);
        this._a.sayHi();
        this.doSomething();
    }

    doSomething()
    {
        this._a.doSomething();
    }
}

class A
{
    sayHi() {
        console.log(`Hello!`);
    }

    doSomething()
    {
        console.log(`doSomething`);
    }
}
A.CLASSES = [B.name];


const friender = (object, arrAllowedClasses) => new Proxy(
    object,
    {
        get (object, strProperty) {
            try {
                throw new Error(`Called`);
            } catch (err) {
                // ugh!
                strCaller = err.stack
                    .split(`at `)[2]
                    .split(` (`)[0]
                    .replace(/new /, ``)
                    .replace(/\..*/, ``);
                console.debug(`${strProperty} requested from instance of ${strCaller}`);
                if (!arrAllowedClasses.includes(strCaller)) {
                    throw new Error(`Disallowed call to instance of ${object.constructor.name} from non-friend class ${strCaller}`);
                }
                return object[strProperty];
            }

        }
    }
);

const b = new B();
b.doSomething();

const c = new C();
c.doSomething();
