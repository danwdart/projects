import {createServer, get} from 'http';
import handleRequest from './handleRequest';

createServer()
    .on(`request`, handleRequest)
    .listen(process.env.PORT || 8080)
    .on(`started`, () => get(`http://localhost:8080`, msg => console.log(msg.read())));