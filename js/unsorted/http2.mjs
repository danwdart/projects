import http2 from 'http2';
import {readFileSync} from 'fs';

const cert = readFileSync('certificate.pem');
const key = readFileSync('key.pem');

const server = http2.createSecureServer({cert, key});
server.on(`stream`, (stream, headers) => {
    stream.on('push', responseHeaders => console.log(responseHeaders));
    stream.on('data', chunk => console.log(chunk));
    stream.on('end', () => console.log('end'));
    stream.respond({':status': 200});
    stream.end(`<!doctype html><meta charset="utf-8"><img src="/"><script src="/"></script><script>fetch("/").then(console.log);</script>`);
});

server.listen(process.PORT || 8443);