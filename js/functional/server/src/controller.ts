import {IncomingHttpHeaders, OutgoingHttpHeaders} from 'http';


export default (
    method: string,
    url: string,
    headers: IncomingHttpHeaders,
    body: string
) : {
    statusCode: number,
    headers: OutgoingHttpHeaders,
    body: string
} => ({
    statusCode: 200,
    headers: {
        Server: `Weird thing Dan made`,
        'Content-Type': 'application/json'
    },
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