import fetch from 'node-fetch';
import {grab} from './lib/grab';
import download from 'download';

const grabWithFetch = grab(fetch);

(async () => {
    try {
        await Promise.all(
            await (
                await grabWithFetch(process.argv[2])
            )
            .map(x => x.large_file_url)
            .map(fileUrl => download(fileUrl, 'images'))
        );
    } catch (err) {
        console.error(err);
    }
})();