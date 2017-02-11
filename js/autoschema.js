class AutoSchema
{
    static getFields()
    {
        throw new Error('No fields defined');
    }

    static create(arrData)
    {
        return new Proxy(
            new this.constructor(arrData),
            {
                get(what, field) {
                    if (what.)
                },

                set(what, field, value) {

                }
            }
        )
    }
}

class Model extends AutoSchema
{
    static getFields()
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
