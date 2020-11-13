const dec = c => c.dec = 1,
    decf = v => c => c.decf = v,
    decm = (t, k, d) => t.k = 3,
    decmf = v => (t, k, d) => t.k = v;

@dec
@decf(1)
class A {
    @decm
    @decmf(2)
    sayHi()
    {
        console.log("hi");
    }
}
