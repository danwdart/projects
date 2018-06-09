// Describe stateless, memoisable changes
function memoise(obj, fn, desc) {
    const saved = {};
    console.log(`Memoising`, fn);
    const oldfn = obj[fn];
    obj[fn] = (...args) => {
        const ret = oldfn(...args),
            [objObj, arrArgs] = [...args],
            strObj = JSON.stringify(objObj),
            strArgs = JSON.stringify(arrArgs);

        if (saved?.[fn]?.[strObj]?.[strArgs]) {
            console.log(`from cache (${fn}.${strObj}.${strArgs}) = ${JSON.stringify(ret)}`);
            return saved[fn][strObj][strArgs];
        }
        console.log(`new (${fn}.${strObj}.${strArgs}) = ${JSON.stringify(ret)}`);
        if (!saved[fn]) {
            saved[fn] = {};
        }
        if (!saved[fn][strObj]) {
            saved[fn][strObj] = {};
        }
        saved[fn][strObj][strArgs] = ret;
        return ret;
    };
    return obj[fn];
}

const Books = {
    @memoise push: (books, book) => {
        const newBooks = [...books];
        newBooks.push(book);
        return newBooks;
    }
};

const Person = {
    @memoise setName: (person, name) => {
        const {...newPerson} = {...person};
        newPerson.name = name;
        return newPerson;
    },
    @memoise setAge: (person, age) => ({...person, age}),
    @memoise format: person => `${person.name} is ${person.age} and has the following books: ${person.books.join(`, `)}`,
    @memoise addBook: (person, book) => ({...person, books: Books.push((person.books || (person.books = [])), book)})
};

console.log(
    Person.format(
        Person.setAge(
            Person.addBook(
                Person.setAge(
                    Person.setAge(
                        Person.setAge(
                            Person.setName(
                                {
                                    name: `Bob`,
                                    age: 23
                                },
                                `Dan`
                            ),
                            26
                        ),
                        26
                    ),
                    26
                ),
                `The Latin Kingdoms`
            ),
            26
        )
    )
);
