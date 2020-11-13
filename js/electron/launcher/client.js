const fs = require(`fs-extra`),
    ini = require(`ini`);

(async () => {
    const appdir = `/usr/share/applications`,
        apps = (await Promise.all(
            (await fs.readdir(appdir)).map(
                async apppath => [apppath, await fs.lstat(`${appdir}/${apppath}`)]
            ).filter(
                async arrFilenameAndStat => (await arrFilenameAndStat)[1].isFile()
            ).map(
                async arrFilenameAndStat => {
                    try {
                        return await fs.readFile(`${appdir}/${(await arrFilenameAndStat)[0]}`);
                    } catch (err) {
                        return ``;
                    }
                }
            )
                .filter(async buffer => (await buffer).length)
                .map(async buffer => (await buffer).toString())
                .map(async strFile => ini.parse(await strFile))
                .map(async objIni => (await objIni)[`Desktop Entry`])
                .map(async objApp => {
                    const app = await objApp || {},
                        exec = app.Exec || ``,
                        icon = app.Icon || ``,
                        name = app.Name || ``;
                    return `<a href="${exec}"><img src="${icon}" alt="" /> ${name}</a>`;
                })
        )).join(`<br/>`);
    document.querySelector(`main`).innerHTML = apps;
})();
