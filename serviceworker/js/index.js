navigator.serviceWorker.register('worker.js', {scope: './'}).then(()=>{
    console.log("Worker registered");
});

//import fake from './fake';
