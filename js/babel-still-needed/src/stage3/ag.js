async function* makeStuff()
{
    await 1;
    await 2;
}

async function getStuff()
{
    for await (let val of makeStuff()) {
        console.log(val);
    }
}
