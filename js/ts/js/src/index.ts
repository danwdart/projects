export namespace Stuff.Things
{
    export class A
    {
        constructor(
            public name: string
        )
        {
        }

        public sayHello(tosay: string): void
        {
            console.log(`${this.name} says: ${tosay}`)
        }
    }

    new A(`Bob`).sayHello(`Hi`);
}
