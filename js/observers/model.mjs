import Observable from './observable';

export default class Model
{
    constructor()
    {
        this.name = new Observable();
    }
}
