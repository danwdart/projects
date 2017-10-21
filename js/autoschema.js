class AutoSchema
{
    static getFields()
    {
        throw new Error('No fields defined');
    }

    constructor(arrData)
    {
        const symFields = Symbol("FIELDS");
        return new Proxy(
            new this.constructor(arrData),
            {
                get(what, field) {
                    if (what[symFields][field])
                },

                set(what, field, value) {

                }
            }
        )
    }
}

class Model extends AutoSchema
{
    static getFields =
    {
        return ['a'];
    }
}

let m = new Model();
m.a = 'a';
try {
    m.b = 'b';
} catch (err) {
    throw new Error("No error"); // wtf?
}
