import {IncomingMessage, ServerResponse, METHODS, STATUS_CODES} from 'http';
import {Writable as WritableStream} from 'stream';
import controller from './controller';

export default (message: IncomingMessage, response: ServerResponse): void => {
    const {statusCode, headers, body} = controller(
        message.method,
        message.url,
        message.headers,
        message.read() as string
    )
    headers.forEach(([key, value]) => response.setHeader(key, value));
    response.statusCode = Number(String(200) as keyof STATUS_CODES);
    response.end(body);
};