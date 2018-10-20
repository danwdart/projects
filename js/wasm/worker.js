(async () => {
    self.addEventListener('message', async msg => {
        self.postMessage(`Echo: ${msg.data}`);
        if (`Go!` === msg.data) {
            self.postMessage(`OK so...`);
            try {
                const results = await WebAssembly.instantiateStreaming(fetch('hello.wasm'), {});
                console.log(results);
            } catch (err) {
                self.postMessage(err);
            }
            self.postMessage(`Hmmmm`)
            self.postMessage(results);
        
            results.instance.exports.main();
        }
    });
   
})();