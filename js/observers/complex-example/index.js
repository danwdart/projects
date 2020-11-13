import {Observable} from './lib/observable.js';
import {Person} from './lib/person.js';

const qs = document.querySelector.bind(document),
    elButton = qs(`button`),
    elNumClicks = qs(`#clicks`),
    elTbody = qs(`tbody`),
    clickObservable = new Observable(),
    ajaxObservable = new Observable(),
    jsonObservable = new Observable(),
    newTableRows = new Observable(),
    numClicksObservable = new Observable();

let numClicks = 0;

numClicksObservable.subscribe(
    () => elNumClicks.innerHTML = numClicks
);

newTableRows.subscribe(
    arr => elTbody.innerHTML = arr.map(
        row => `<tr><td>${row.name.value}</td><td>${row.age.value}</td></tr>`
    ).join(``)
);

newTableRows.notify(
    [
        {
            name: new Observable(`Click to load`),
            age: new Observable(``)
        }
    ]
);

jsonObservable.subscribe(
    newArray => newTableRows.notify(
        newArray.map(
            newObj => new Person(newObj)
        )
    )
);

ajaxObservable.subscribe(
    async data => jsonObservable.notify(await data.json())
);
clickObservable.subscribe(
    async () => ajaxObservable.notify(await fetch(`/data.json`))
);
clickObservable.subscribe(
    () => numClicksObservable.notify(numClicks++)
);
elButton.addEventListener(
    `click`,
    (ev) => clickObservable.notify(ev)
);
