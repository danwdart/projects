const worker = new Worker('worker.js');

worker.addEventListener('message', msg => console.log(msg.data));
worker.addEventListener('error', err => console.error(err));

worker.postMessage('Go!');