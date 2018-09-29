export const OPTIONS_DEFAULT = {
    numbers: 100000,
    soundfn: newy => (newy / 10) - 0.5,
    newyFn: sf => sf,
    scale: {
        x: 5,
        y: 5
    },
    tonefn: (i, newx, newy) => ([440 + 10000 * ((newy - 5) / newx), 1, 1 * i])
};

export const TYPES = {
    countfact: {
        sound: true,
        tone: false,
        fn: countfact,
        scale: {
            y: 20
        },
        tone: true
    },
    sumfact: {
        sound: true,
        tone: false,
        fn: sumfact,
        scale: {
            x: 100,
            y: 100
        },
        soundFn = newy => newy,
        newyFn = sf => Math.log(sf) / 2
    },
    sbaudio: {
        sound: true,
        tone: false,
        fn: (() => { const sb = sternbrocot(); return () => sb.next().value; })(),
        soundfn: newy => (Math.log(newy) / 10) - 0.5,
    },
    sbaudiotones: {
        numbers: 1000,
        sound: false,
        tone: true,
        fn: (() => { const sb = sternbrocot(); return () => sb.next().value; })(),
        tonefn: (i, newx, newy) => ([440 * Math.pow(2, (newy / 12)), 50, 50 * i])
    }
}