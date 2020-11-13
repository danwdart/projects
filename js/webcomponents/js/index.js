import JhApp from './components/jh/app/index.js';

customElements.define(`jh-app`, JhApp);

(async () => {
    await customElements.whenDefined(`jh-app`);
    // Do stuff
    await fetch(`js/index.js`);
})();
