export class Observable
{
    constructor(initialValue)
    {
        this.value = initialValue;
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
        this.value = data;
        this.observers.forEach(observer => observer(data));
    }
}
