export default class Person
{
    constructor(name, age, genders)
    {
        this.name = name;
        this.age = age;
        this.genders = genders;
    }

    getName()
    {
        return this.name;
    }
}

export class Me extends Person
{
    constructor(name, age)
    {
        super(name, age, [`all`, `of`, `them`]);
    }
}