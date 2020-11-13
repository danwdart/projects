// @flow
class A
{
    constructor(name: string)
    {
        this.name = name;
    }

    sayHello(tosay: string): void
    {
        console.log(`${this.name} says: ${tosay}`)
    }
}

new A(`Bob`).sayHello(`Hi`);
