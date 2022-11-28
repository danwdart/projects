import {grab} from './lib/grab.js';

const $ = document.querySelector.bind(document);
const grabWithFetch = grab(fetch);

$('form').addEventListener('submit', async event => {
    event.preventDefault();
    const search = $('#search').value;
    try {
        $('#images').innerHTML = (await grabWithFetch(search))
            .map(
                ({
                    file_url,
                    image_height,
                    image_width,
                    large_file_url,
                    preview_file_url,
                    source,
                    tag_string
                }) => `<a href="${large_file_url}" title="${tag_string}" target="_blank">` +
                    `<img src="${preview_file_url}" alt="${tag_string}"/>` +
                `</a>`
            ).join(``) || `No images for the search string ${search}. Maybe try other / shorter tags?`
    } catch (err) {
        console.error(err);
    }
});