export default class JhApp extends HTMLElement
{
    constructor()
    {
        super();
        this.render();
    }

    async render()
    {
        let shadowRoot = this.attachShadow({mode: `open`});

        let index = await fetch(`/js/components/jh/title/index.html`),
            dom = await index.text();

        shadowRoot.innerHTML = dom;
    }
}
