const $cfe = $(`#cfe`),
    $dec = $(`#dec`),
    $fracNum = $(`#frac sup`),
    $fracDen = $(`#frac sub`),
    $graph = $(`canvas#graph`);

const calc = () => {
    const cfe = $cfe.val(),
        arr = cfe.split(/[;,]/).filter(v => 0 != v).map(str => Number(str)),
        revarr = arr.reverse(),
        value = revarr.length ? revarr.reduce((t, n) => n + (1 / t)) : 1,
        frac = revarr.length ? revarr.reduce(([n, d], m) => [d + (n * m), n], [1, 0]) : [1, 1];
    $dec.html(value);
    $fracNum.html(frac[0]);
    $fracDen.html(frac[1]);
};



const ENDPOINT = 'https://oeis.org',
      SIZE = 6;

// Modified from node's oeis
const searchBySequence = async (arrSequence, intStart = 0) => 
    await (
        await fetch(`${ENDPOINT}/search?fmt=json&q=${arrSequence.join(',')}&start=${intStart}`, {mode: `no-cors`})
    ).json();

const searchByID = async intID =>
    await (
        await fetch(`${ENDPOINT}/search?fmt=json&q=id:A${intID.padStart(SIZE, `0`)}`)
    ).json();

const plot = async (intID, bPng) => 
    await (
        await fetch(`${ENDPOINT}/A${intID.padStart(SIZE, `0`)}/graph?png=${bPng ? `1` : `0`}`)
    ).text();

$(`#cfe`).on(`keyup`, calc);
$(`#cfe`).on(`change`, calc);
$(`button[data-cfe]`).on(`click`, ev => {
    $cfe.val($(ev.target).data(`cfe`));
    calc();
});