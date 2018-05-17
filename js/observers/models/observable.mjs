export default class Observable
{
    constructor()
    {
        this.observers = [];
    }

    subscribe(fn)
    {
        this.observers.push(fn);
    }

    unsubscribe(fn)
    {
        this.observers = this.observers.filter(observer => fn !== observer);
    }

    notify(data)
    {
        this.observers.forEach(observer => observer(data));
    }
}
