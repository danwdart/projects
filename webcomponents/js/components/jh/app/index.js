import JhTitle from '../title/index.js';
import JhBody from '../body/index.js';
import JhStuff from '../stuff/index.js';

export default class JhApp extends HTMLElement
{
    constructor()
    {
        super();
        customElements.define('jh-title', JhTitle);
        customElements.define('jh-body', JhBody);
        customElements.define('jh-stuff', JhStuff);
        this.render();
    }

    async render()
    {
        await Promise.all([
            customElements.whenDefined('jh-title'),
            customElements.whenDefined('jh-body'),
            customElements.whenDefined('jh-stuff')
        ]);

        let shadowRoot = this.attachShadow({mode: 'open'});

        let index = await fetch("/js/components/jh/app/index.html"),
            dom = await index.text();

        shadowRoot.innerHTML = dom;
    }
}
