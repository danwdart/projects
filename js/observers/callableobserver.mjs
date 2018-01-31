export default function CallableObserver(initialValue)
{
    let value = initialValue,
        observers = [];

    const fnOut = data => {
        if (`undefined` === typeof data) {
            return value;
        }
        value = data;
        fnOut.notify(data);
        return fnOut;
    };

    fnOut.subscribe = fn => {
        observers.push(fn);
        return fnOut;
    };

    fnOut.unsubscribe = fn => {
        observers = observers.filter(observer => fn !== observer);
        return fnOut;
    };

    fnOut.notify = data => {
        observers.forEach(observer => observer(data));
        return fnOut;
    };

    return fnOut;
}
