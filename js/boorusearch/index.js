import {grab} from './lib/grab.js';

const $ = document.querySelector.bind(document);
const grabWithFetch = grab(fetch);

$('form').addEventListener('submit', async event => {
    event.preventDefault();
    const search = $('#search').value;
    
    $('#images').innerHTML = (await grabWithFetch(search))
        .map(
            ({
                file_url,
                image_height,
                image_width,
                large_file_url,
                preview_file_url,
                source,
                tag_string_general
            }) => `<a href="${large_file_url}" target="_blank"><img src="${preview_file_url}"></a>`
        ).join(``)
});