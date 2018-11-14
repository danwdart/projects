const $cfe = $(`#cfe`),
    $dec = $(`#dec`),
    $fracNum = $(`#frac sup`),
    $fracDen = $(`#frac sub`),
    $graph = $(`canvas#graph`);

const getCFEDetails = cfe => {
    const arr = cfe.split(/[;,]/).filter(v => 0 != v).map(str => Number(str)),
        revarr = arr.reverse(),
        value = revarr.length ? revarr.reduce((t, n) => n + (1 / t)) : 1,
        frac = revarr.length ? revarr.reduce(([n, d], m) => [d + (n * m), n], [1, 0]) : [1, 1];
    return [value, frac];
};

const calc = () => {
    const cfe = $cfe.val(),
        [value, frac] = getCFEDetails(cfe);
        
    $dec.html(value);
    $fracNum.html(frac[0]);
    $fracDen.html(frac[1]);
};

$(`#cfe`).on(`keyup`, calc);
$(`#cfe`).on(`change`, calc);
$(`button[data-cfe]`).on(`click`, ev => {
    $cfe.val($(ev.target).data(`cfe`));
    calc();
});