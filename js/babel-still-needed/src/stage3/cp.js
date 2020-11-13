class A
{
    things = 1;
    fun = () => 2;
    static sThings = 3;
    static sFun = () => 4;
}
const a = new A();
console.log(a.things, a.fun(), A.sThings, A.sFun());
