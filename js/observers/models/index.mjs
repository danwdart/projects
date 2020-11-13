import CallableObserver from './callableobserver';
import Model from './model';
import ModelWithCo from './model-with-co';
import Observable from './observable';

// Example 1
{
    const model = new Model();

    model.name.subscribe(newValue => console.log(`DEBUG: Name changed to ${newValue}`));

    model.name.notify(`Bob`);
    model.name.notify(`Dan`);
}

// Example 2
{
    const callable = CallableObserver(1),
        cb = newValue => console.log(`Callable said new value was ${newValue}`);

    callable.subscribe(cb);

    callable(2);
    callable(3);

    callable.unsubscribe(cb);

    callable(4);

    callable.subscribe(cb);

    callable(5);
}

// Example 3
{
    const fn = (newValue) => console.log(`Changed: ${newValue}`);

    console.log(CallableObserver()(11)());

    const co = CallableObserver(1)
        .subscribe(fn)(3)(2)(1)
        .unsubscribe(fn)(0)
        .subscribe(fn)(5);

    console.log(`Final value was: ${co()}`);
}

// Example 4
{
    const model = new ModelWithCo(),
        debugFn = newName => console.log(`The name was set to ${newName}`),
        recurseFn = () => {
            if (5 < model.name().length) {
                return;
            }
            model.name(`${model.name()}+`);
        };

    model.name.subscribe(debugFn);
    model.name.subscribe(recurseFn);

    model.name(`Bob`);
    model.name(`Dan`);

    console.log(`Final name: ${model.name()}`);
}

// Example 5
{
    const observable = new Observable(),
        logAChange = newValue => console.log(`A value changed to ${newValue}`),
        logAChangeInADifferentWay = newValue => console.log(`Oh, by the way, a value changed to ${newValue}`);

    observable.subscribe(logAChange);
    observable.subscribe(logAChangeInADifferentWay);

    const a = setInterval(() => observable.notify(process.uptime()), 1000);
    setTimeout(() => clearInterval(a), 3500);
}
