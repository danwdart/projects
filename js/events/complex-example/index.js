import EventEmitter from './node_modules/EventEmitter/src/index.js';
import {Person} from './lib/person.js';

const qs = document.querySelector.bind(document),
    elButton = qs(`button`),
    elNumClicks = qs(`#clicks`),
    elTbody = qs(`tbody`),
    eventHandler = new EventEmitter();

let numClicks = 0;

eventHandler.on(
    `numClicks`,
    () => elNumClicks.innerHTML = numClicks
);

eventHandler.on(
    `newTableRows`,
    arr => elTbody.innerHTML = arr.map(
        row => `<tr><td>${row.name}</td><td>${row.age}</td></tr>`
    ).join(``)
);

eventHandler.emit(
    `newTableRows`,
    [
        {
            name: `Click to load`,
            age: ``
        }
    ]
);

eventHandler.on(
    `json`,
    newArray => eventHandler.emit(
        `newTableRows`,
        newArray.map(
            newObj => new Person(newObj)
        )
    )
);

eventHandler.on(
    `ajax`,
    async data => eventHandler.emit(`json`, await data.json())
);

eventHandler.on(
    `click`,
    async () => eventHandler.emit(`ajax`, await fetch(`/data.json`))
);

eventHandler.on(
    `click`,
    () => eventHandler.emit(`numClicks`, numClicks++)
);

elButton.addEventListener(
    `click`,
    (ev) => eventHandler.emit(`click`, ev)
);
