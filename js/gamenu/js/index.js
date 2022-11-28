import {json} from './lib/mock.js';
import {menu} from './lib/menu.js';

const prop = p => o => o[p];
const eq = a => b => a === b;

const compose = f => g => x => f(g(x));
const flip = f => y => x => f(x)(y);
const find = on => fn => on.find(fn);
const on = f => g => x => y => f(g(x))(g(y));
const d2 = f => g => h => i => j => f(g(h))(i(j));

const findMenuItem = compose(find(json))(flip(d2(eq)(on(compose)(prop)('menu')('dataset')))(prop('id')));

const getTarget = prop('currentTarget');

const Maybe = x => ({
    unwrap: () => x,
    map: f => x ? Maybe(f(x)) : Maybe(null),
    //ap: v => Maybe(x(v.unwrap()))
});

const getData = compose(flip(compose)(prop('dataset')))(prop);

const IO = io => ({
    performUnsafeIO: io,
    map: f => IO(() => f(io()))
});

const replaceMenu = me =>
    //eslint-disable-next-line cleanjs/no-mutation
    document.querySelector('main').innerHTML = menu(findMenuItem(me));

const logAction = me =>
    console.log(me.dataset.action);

const addClicks = () => document.querySelectorAll('.menuitem').forEach(
    menuitem => menuitem.addEventListener('click', clickMenu)
);

const iff = a => b => c => a ? b : c;

const clickTarget = me => IO(
    // TODO EitherIO
    iff(getData('menu')(me))(() => replaceMenu(me))(()=>0)
)
    .map(iff(getData('action')(me))(() => logAction(me))(()=>0))
    .map(addClicks)
    .performUnsafeIO();

const clickMenu = compose(clickTarget)(getTarget);

const main = IO(() =>
    //eslint-disable-next-line cleanjs/no-mutation
    document.querySelector('main').innerHTML = menu(json[0])
).map(
    addClicks
);

//eslint-disable-next-line cleanjs/no-unused-expression
main.performUnsafeIO();