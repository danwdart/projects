import {createServer} from 'http';
import handleRequest from './handleRequest';

createServer()
    .on(`request`, handleRequest)
    .listen(process.env.PORT || 8080);