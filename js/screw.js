// Setup
{
    let _prop = 0;

    Object.defineProperty(
        global,
        "prop",
        {
            get() {
                return _prop++;
            },

            set() {
                console.log(`Haha, nope.`);
                return _prop++;
            }
        }
    );
}

// Program
{
    // Huh? It's changing?
    console.log(prop);
    console.log(prop);
    console.log(prop);
    console.log(prop);
    console.log(prop);
    prop = 2;
    // oh no...
    console.log(prop);
    console.log(prop);
    console.log(prop);
}
