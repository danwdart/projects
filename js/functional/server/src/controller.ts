import {IncomingHttpHeaders, OutgoingHttpHeaders, STATUS_CODES, METHODS} from 'http';
import {URL} from 'url';

export default (
    method: METHODS[keyof METHODS],
    url: URL,
    headers: IncomingHttpHeaders,
    body: String
) : {
    statusCode: keyof STATUS_CODES,
    headers: OutgoingHttpHeaders,
    body: string
} => ({
    statusCode: String(200),
    headers: new Map([[`Server`, `Weird thing Dan made`]]),
    body: JSON.stringify(
        {
            method,
            url,
            headers,
            body,
            version: 1
        }
    )
});