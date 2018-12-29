import {delay} from './lib/delay';

(async () => {
    try {
        await delay(500);
        await delay(500);
        console.log('Done');
        await delay(500);
        // eslint-disable-next-line cleanjs/no-throw
        throw new Error('foo');
        //await delay(500);
        //console.log('Done');
    } catch (err) {
        console.error(err);
    }
})();