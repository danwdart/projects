import {IncomingHttpHeaders, OutgoingHttpHeaders, STATUS_CODES} from 'http';

export default (method: string, url: string, headers: IncomingHttpHeaders, body: String) : {
    statusCode: keyof STATUS_CODES,
    headers: Map,
    body: string
} => ({
    statusCode: String(200) as keyof STATUS_CODES,
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