import {IncomingMessage, ServerResponse} from "http";
import controller from "./controller";

export default (message: IncomingMessage, response: ServerResponse): void => {
    const {statusCode, headers, body} = controller(
        message.method as string,
        message.url as string,
        message.headers,
        message.read() as string,
    );
    Object.entries(headers).forEach(
        ([key, value]: [string, any]) =>
            response.setHeader(key, value),
    );
    response.statusCode = statusCode;
    response.end(body);
};
