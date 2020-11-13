import {IncomingHttpHeaders, OutgoingHttpHeaders} from "http";

export default (
    method: string,
    url: string,
    headers: IncomingHttpHeaders,
    body: string,
): {
    body: string,
    headers: OutgoingHttpHeaders,
    statusCode: number,
} => ({
    body: JSON.stringify(
        {
            body,
            headers,
            method,
            url,
            version: 1,
        },
    ),
    headers: {
        "Content-Type": "application/json",
        "Server": `Weird thing Dan made`,
    },
    statusCode: 200,
});
