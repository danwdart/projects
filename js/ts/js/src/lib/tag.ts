import { selfClosingTags } from './html';

export default class Tag
{
    private attrs: Map<string, string> = new Map();
    private children: Set<Tag | string> = new Set();
    private selfClosing: boolean = false;
    private empty: boolean = false;
    private nl = "\n";

    constructor(public type: string)
    {
    }

    add(child: Tag | string): Tag {
        if (child instanceof Tag) {
            this.children.add(child);
            return this;
        }

        this.children.add(child);

        return this;
    }

    setAttribute(attribute: string, value?: string): Tag
    {
        if (`undefined` === typeof value) {
            value = "true";
        }

        this.attrs.set(attribute, <string>value);

        return this;
    }

    toString(): string {
        if (this.empty) {
            return Array.from(this.children).join(``);
        }

        const strAttrs: string = Array.from(this.attrs.entries()).map(
            ([attr, attrValue]) => ("true" === attrValue) ?
                attr :
                `${attr}="${attrValue}"`
        ).join(` `);

        const selfClosing = selfClosingTags.includes(this.type);

        const strChildren: string = selfClosing ?
            "":
            Array.from(this.children.values()).join(``); // nl?

        return `<${this.type}${strAttrs ? ` ` + strAttrs : ``}` + (
            selfClosing ?
                `>` : // html5
                (`>` + strChildren + `</${this.type}>`)
        );
    }

    valueOf(): string {
        return this.toString();
    }
}
