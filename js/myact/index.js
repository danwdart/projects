const e = (t,o,c)=>`<${t}${o?` ${o.map(([k,v])=>`${k}="${v}"`).join(` `)}`:``}>${c.join(``)}</${t}>`;

console.log(e(`h1`,[[`class`,`magic`]],[e(`span`,[[`class`,`three`]],[`hi`])]));