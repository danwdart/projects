const hosts = [
    "https://danbooru.donmai.us/posts.json?tags=",
    "https://safebooru.donmai.us/posts.json?tags=",
];

import splitCombos from './split-combos.js';
import unique from './unique.js';

export const grab = fetch => async search => {
    const searchTerms = search.split(` `);
    const searchQueryTerms = splitCombos(2)(searchTerms);
    return unique(x => x.source)((await Promise.all(
        hosts.map(
            async host => (
                await Promise.all(
                    searchQueryTerms.map(
                        async searchQueryTerm => {
                            let page = 1;

                            let full = [];
                        
                            while (true) {
                                const json = await (
                                    await fetch(`${host}${searchQueryTerm}&page=${page}`)
                                ).json();
                            
                                if (!json.length) {
                                    break;
                                }

                                full = [...full, ...json];

                                page++;
                            }

                            return full;
                        }
                    )
                )
        )
    )))
    .flat(3)
    .filter(x => x.source)
    .filter(x => !(searchTerms.map(
        tag => x.tag_string.includes(tag)
    ).includes(false))));
};