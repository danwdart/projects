class AutoTree
{
    static create()
    {
        return new Proxy(
            new AutoTree(),
            {
                get(target, name) {
                    if ('undefined' == typeof target[name]) {
                        target[name] = AutoTree.create();
                    }
                    return target[name];
                }
            }
        );
    }
}

let a = AutoTree.create();

a.b.c.d.e.f.g = 'h';

console.log(a.b.c.d.e.f.g);
