import {delay} from './lib/delay';

(async () => {
    try {
        await delay(500);
        await delay(500);
        console.log('Done');
        await delay(500);
        throw new Error('foo');
        await delay(500);
        console.log('Done');
    } catch (err) {
        console.error(err);
    }
})();