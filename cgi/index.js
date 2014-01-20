#!/usr/bin/node
console.log('Content-Type: text/html');
console.log('X-Powered-By: Dans-Node-App/1.0')
console.log('');
console.log('<h1>Hello World!</h1>');
console.log('Your User Agent Is '+process.env['HTTP_USER_AGENT']);
