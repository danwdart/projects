/*
Definitions
When the expression to check is not defined at all in the block:
*/
{
    console.log("Never defined");
    const f = ('undefined' !== typeof bob && null !== bob && ({a,b,c} = bob) && a + b + c || "Not 'ere guv'na!");
    console.log({f});
}
/*
This is OK!
When the expression to check is defined earlier:
*/
{
    console.log("Defined earlier");
    const bob = {a:1,b:2,c:3};
    const f = ('undefined' !== typeof bob && null !== bob && ({a,b,c} = bob) && a + b + c || "Not 'ere guv'na!");
    console.log({f});
}
/*
Or is null:
*/
{
    console.log("Null");
    const bob = null;
    const f = ('undefined' !== typeof bob && null !== bob && ({a,b,c} = bob) && a + b + c || "Not 'ere guv'na!");
    console.log({f});
}
/*
    This is also OK!
When the expression to check is defined later:
*/
{
    console.log("Defined later");
    try {
        // Uh-oh! ReferenceError!
        // Firefox: ReferenceError: can't access lexical declaration `bob' before initialization
        // Node: ReferenceError: bob is not defined
        const f = ('undefined' !== typeof bob && null !== bob && ({a,b,c} = bob) && a + b + c || "Not 'ere guv'na!");
        const bob = {a:1,b:2,c:3};
        console.log({f});
    } catch (err) {
        console.error(`That was an error. The error was "${err.message}"!`);
    }
}

{
    console.log("Never defined");
    const f = ('undefined' !== typeof bob && null !== bob && ({a,b,c} = bob) && a + b + c || "Not 'ere guv'na!");
    console.log({f});
}
/*
This is OK!
When the expression to check is defined earlier:
*/
{
    console.log("Defined earlier");
    let bob = {a:1,b:2,c:3};
    const f = ('undefined' !== typeof bob && null !== bob && ({a,b,c} = bob) && a + b + c || "Not 'ere guv'na!");
    console.log({f});
}
/*
Or is null:
*/
{
    console.log("Null");
    let bob = null;
    const f = ('undefined' !== typeof bob && null !== bob && ({a,b,c} = bob) && a + b + c || "Not 'ere guv'na!");
    console.log({f});
}
/*
    This is also OK!
When the expression to check is defined later:
*/
{
    console.log("Defined later");
    try {
        // Uh-oh! ReferenceError!
        // Firefox: ReferenceError: can't access lexical declaration `bob' before initialization
        // Node: ReferenceError: bob is not defined
        const f = ('undefined' !== typeof bob && null !== bob && ({a,b,c} = bob) && a + b + c || "Not 'ere guv'na!");
        let bob = {a:1,b:2,c:3};
        console.log({f});
    } catch (err) {
        console.error(`That was an error. The error was "${err.message}"!`);
    }
}