const {app, BrowserWindow} = require(`electron`),
    path = require(`path`),
    url = require(`url`);

let win;

function createWindow () {
    win = new BrowserWindow({width: `max`, height: `max`});

    win.loadURL(url.format({
        pathname: path.join(__dirname, `index.html`),
        protocol: `file:`,
        slashes: true
    }));

    // Emitted when the window is closed.
    win.on(`closed`, () => win = null);
}

app.on(`ready`, createWindow);

app.on(`window-all-closed`, () => {
    if (process.platform !== `darwin`) {
        app.quit();
    }
});

app.on(`activate`, () => {
    if (win === null) {
        createWindow();
    }
});
