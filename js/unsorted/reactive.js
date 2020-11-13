// Object oriented
const reactifier = object => {
    const record = [];

    return new Proxy(
        object,
        {
            get: (on, what) => {
                if (`record` === what) {
                    return record;
                }
                return on[what];
            },
            set: (on, what, which) => {
                record.push({[what]: which});
                return on[what] = which;
            }
        }
    );
};

const reactiveObject = reactifier({});

reactiveObject.myProp = 1;
reactiveObject.myProp2 = 2;
reactiveObject.myProp3 = 3;

console.log({reactiveObject})
console.log({reactiveObjectRecord: reactiveObject.record});


// Stateful
const statefulReactive = {
    state: null,
    record: [],
    setState: stateFn => {
        const newState = stateFn(statefulReactive.state);
        statefulReactive.record.push(newState);
        statefulReactive.state = newState;
    }
};

statefulReactive.setState(() => ({thingy: 1, otherThingy: 2}));
statefulReactive.setState(state => ({...state, thingy: 2}));
console.log({statefulReactiveState: statefulReactive.state});
console.log({statefulReactiveRecord: statefulReactive.record});