const tmpl = [
    {
        num: 1,
        name: 'One'
    },
    {
        num: 2,
        name: 'Two'
    },
    {
        num: 3,
        name: 'Three'
    },
    {
        num: 4,
        name: 'Four'
    },
    {
        num: 5,
        name: 'Five'
    }
];

export const json = [
    {
        id: 'default',
        items: tmpl.map(({num, name}) => ({menu: `menu${num}`, name}))
    },
    ...tmpl.map(({num, name: name1}) => ({
        id: `menu${num}`,
        items: [
            ...tmpl.map(({num, name}) => ({action: `hi ${num}`, name: `${name1} ${name}`})),
            {
                menu: 'default',
                name: 'Back'
            }
        ]
    }))
];