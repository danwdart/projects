// The list way

class B
{
    b()
    {
        return `b`;
    }
}

class C
{
    c()
    {
        return `c`;
    }
}

class D
{
    d()
    {
        return `d`;
    }
}

const compose = arrClasses => {
    const cl = class {};
    arrClasses.forEach(c =>
        Object.getOwnPropertyNames(c.prototype).filter(n => `constructor` !== n).forEach(m =>
            cl.prototype[m] = c.prototype[m]
        )
    );
    return cl;
};

class A extends compose([B, C, D])
{
    constructor()
    {
        super();
        console.log(this.b(), this.c(), this.d());
    }
}

new A();

// The decorated decorator way
@B
@C
@D
class E
{
    constructor()
    {
        super();
        console.log(this.b(), this.c(), this.d());
    }
}

new E();