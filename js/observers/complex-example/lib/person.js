import {Observable} from './observable.js';

export class Person
{
    constructor({name, age})
    {
        this.name = new Observable(name);
        this.age = new Observable(age);
    }
}
