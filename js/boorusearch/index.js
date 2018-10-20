const $ = document.querySelector.bind(document);

$('form').addEventListener('submit', async event => {
    event.preventDefault();
    const search = $('#search').value;

    const hosts = [
        "https://danbooru.donmai.us/posts.json?tags=",
        "https://safebooru.donmai.us/posts.json?tags=",
    ];

    $('#images').innerHTML = (await Promise.all(search.split(` `).map(
        async searchTerm => await Promise.all(hosts.map(
            async host => (await (await fetch(`${host}${searchTerm}`)).json())
                .filter(x => x.source)
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
                )
        ))
    ))).join(`<br>`)
});