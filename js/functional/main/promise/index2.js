import {constant} from './lib/combinators';
import {delay} from './lib/delay';

const doneMsg = constant('Done!');
const die = Promise.reject('Error!');

delay(500)
    .then(delay(500))
    .then(doneMsg)
    .then(console.log)
    .then(delay(500))
    .then(die) // oh no... what? why doesn't this stop things?
    // don't we have chains?
    // none of this...
    .then(delay(500))
    .then(doneMsg)
    .then(console.log)
    // should run
    .catch(console.error);