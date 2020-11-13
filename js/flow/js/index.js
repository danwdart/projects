//      
class A
{
    constructor(name        )
    {
        this.name = name;
    }

    sayHello(tosay        )      
    {
        console.log(`${this.name} says: ${tosay}`);
    }
}

new A(`Bob`).sayHello(`Hi`);
