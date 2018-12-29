import {json} from './lib/mock.js';
import {menu} from './lib/menu.js';

const prop = p => o => o[p];
const eq = a => b => a === b;

const compose = f => g => x => f(g(x));
const flip = f => y => x => f(x)(y);
const call = f => x => f(x);
const applyTo = x => f => f(x);

const find = on => fn => on.find(fn);

const on = f => g => x => y => f(g(x))(g(y));

const b3 = f => g => h => x => f(g(h(x)));
const d2 = f => g => h => i => j => f(g(h))(i(j));
/*
"D" = B2
"B1" = B3
"D1" = B4
"B3" = B5
"D2" = B6
"E" = B7
"B2" = B8
"Ê" =  E(E)

B(B) = B^2 = B2
B(B(B)) = B(B2) = B^3 = B4
B(B(B(B))) = B^4 = B(B^3) = B(B4) = B8

???
B(B(B(B(B)))) = B^5 = B(B^4) = B(B8) = B16
???

B^x = B((x-1)^2)
*/

const findMenuItem = compose(find(json))(flip(d2(eq)(on(compose)(prop)('menu')('dataset')))(prop('id')));

const getTarget = prop('currentTarget');

const Maybe = x => ({
    unwrap: () => x,
    map: f => x ? Maybe(f(x)) : Maybe(null),
    //ap: v => Maybe(x(v.unwrap()))
});

const ifThen = then => iff => iff ? then : null;

const getData = compose(flip(compose)(prop('dataset')))(prop);

const IO = io => ({
    performUnsafeIO: io,
    map: f => IO(() => f(io))
});

const ioReplaceMenu = me => IO(() => 
    document.querySelector('main').innerHTML = menu(findMenuItem(me)))

const ioLogAction = me => IO(() => 
    console.log(me.dataset.action));

const ioAddClicks = IO(() => document.querySelectorAll('.menuitem').forEach(
    menuitem => menuitem.addEventListener('click', clickMenu)
));

const debug = v => console.log(v) || v;

const clickMenu = ev => {
    const me = getTarget(ev);
    
    if (getData('menu')(me)) {
        ioReplaceMenu(me).performUnsafeIO();
    }

    if (getData('action')(me)) {
        ioLogAction(me).performUnsafeIO();
    }

    ioAddClicks.performUnsafeIO();
};

const main = IO(() => {
    IO(() => document.querySelector('main').innerHTML = menu(json[0])).performUnsafeIO()
    ioAddClicks.performUnsafeIO();
});

main.performUnsafeIO();

