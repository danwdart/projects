import Tag from './tag';

export default class Pagen
{
    render(): string
    {
        const doctype = new Tag(`!doctype`).setAttribute(`html`),
            meta = new Tag(`meta`).setAttribute(`charset`, `utf-8`),
            title = new Tag(`title`).add(`My Title`),
            head = new Tag(`head`).add(meta).add(title),
            img = new Tag(`img`).setAttribute(`src`, `image.png`),
            body = new Tag(`body`).add(img),
            html = new Tag(`html`).add(head).add(body);
        return doctype.toString() + html.toString();
    }

    toString(): string
    {
        return this.render();
    }
}
