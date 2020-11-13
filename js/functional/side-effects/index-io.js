import fs from 'fs';

const FILE = 'a';

// const IO = f => () => f(); // no-op
const unwrapIO = io => io();
const mapIO = f => io => () => f(unwrapIO(io));

// First function only way (could use pipelines here)

console.log('defining');

const first = () => fs.writeFileSync(FILE, '{"I have no idea": "How this is happening"}');

const second = () => console.debug('hi, just some kind of debug in between');

const third = () => fs.readFileSync(FILE).toString();

console.log('combining');
const allIO = mapIO(console.log)(mapIO(third)(mapIO(second)(first)));
console.log('Starting');
unwrapIO(allIO);
console.log('Finished');

// Maybe pipelines

// const allIO2 = first |> mapIO(second) |> mapIO(third) |> mapIO(console.log) |> unwrapIO;

// Using thrush is just the opposite...
const thrush = x => f => f(x);

thrush(
    thrush(
        thrush(
            thrush(
                first
            )(
                mapIO(second)
            )
        )(
            mapIO(third)
        )
    )(
        mapIO(console.log)
    )
)(
    unwrapIO
);

// Rawness
const b = mapIO(second)(first);
const c = mapIO(third)(b);
const d = mapIO(console.log)(c);
unwrapIO(d);

// Open everything at once...
console.log(third(second(first())));

// Or compose...
const compose = f => g => x => f(g(x));
console.log(compose(third)(second)(first()));


// OK, let's try to make an object chainer
console.log('def');

const MyIO = f => ({
    unwrap: f,
    map: g => MyIO(() => g(f()))
});

const ios3 = MyIO(first).map(second).map(third).map(console.log);
ios3.unwrap();

console.log('Define');
const procs = [
    first,
    second,
    third,
    console.log
];
console.log('Run');
procs.reduce((prev, current) => current(prev));
console.log('Done');

/*
    console.debug('hi, just some kind of debug in between');
    const buf = await readFile(FILE);
    const output = buf.toString();
    const decoded = JSON.parse(output);
    const rnd = Math.random(); // oooh, non-determinism...
    console.log(`We are in the ${0.5 > rnd ? 'bottom' : 'top'}`);
    console.log('The output is %o, the rand was %d and I are gewd', decoded, rnd);
    await unlink(FILE);
    // hmmmmm network
    try {
        const response = await new Promise((res, rej) => 
            https.get('https://dandart.co.uk', response => 200 === response.statusCode ?
                res(response) :
                rej(new Error('Not 200'))
            )
        );
        let responseString = '';
        for await (let dataChunk of response) {
            responseString += dataChunk.toString();
        }

        const {document} = new JSDOM(responseString).window;
        const awesomeMeta = document.querySelector('meta[http-equiv="Who-is-awesome"]');
        const awesomePerson = awesomeMeta.getAttribute('content');
        console.log(awesomePerson, 'is awesome.');
    } catch (err) {
        console.error('oh no', err.message);
    }
    
})();*/