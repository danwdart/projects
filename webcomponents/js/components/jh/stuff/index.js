import indexTemplate from './index.template.js';

export default class JhApp extends HTMLElement
{
    constructor()
    {
        super();
        this.render();
    }

    render()
    {
        let shadowRoot = this.attachShadow({mode: 'open'});
        shadowRoot.innerHTML = indexTemplate;
    }
}
