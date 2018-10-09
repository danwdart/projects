const $ = document.querySelector.bind(document),
    //$$ = document.querySelectorAll.bind(document),
    //on = name => fn => de => de.addEventListener(name, fn),
    onNoDefault = name => fn => de => de.addEventListener(
        name,
        ev => {
            ev.preventDefault();
            fn();
        }
    ),
    onClick = onNoDefault(`click`),
    proxyGen = (prefix, fn) => new Proxy({}, {get: (on, what) => fn(`${prefix}${what}`)}),
    byId = proxyGen(`#`, $),
    // byClass = proxyGen(`.`, $$),
    invokeWith = arg => fn => fn.bind(null, arg);

export const dom = (draw, clickPlayAsAudio, clickPlayAsTones) => {
    const typefn = () => $(`input[type="radio"]:checked`).value,
        invokeWithType = invokeWith(typefn);
    onClick(invokeWithType(draw))(byId.draw);
    onClick(invokeWithType(clickPlayAsAudio))(byId.playAsAudio);
    onClick(invokeWithType(clickPlayAsTones))(byId.playAsTones);
};
