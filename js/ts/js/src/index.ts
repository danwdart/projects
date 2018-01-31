export namespace Stuff.Things
{
    export class A
    {
        private name: string;

        constructor(name: string)
        {
            this.name = name;
        }

        public sayHello(tosay: string): void
        {
            console.log(`${this.name} says: ${tosay}`)
        }
    }

    new A(`Bob`).sayHello(`Hi`);
}
