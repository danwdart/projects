import fetch from 'node-fetch';
import {grab} from './lib/grab';
import download from 'download';

const grabWithFetch = grab(fetch);

(async () => {
    try {
        console.log(
            await grabWithFetch(process.argv[2])
        );
    } catch (err) {
        console.error(err);
    }
})();