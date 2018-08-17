var _obj, _init, _obj2, _init2, _init3, _init4, _init5;

function _extends() { _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; }; return _extends.apply(this, arguments); }

function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _applyDecoratedDescriptor(target, property, decorators, descriptor, context) { var desc = {}; Object[`ke` + `ys`](descriptor).forEach(function (key) { desc[key] = descriptor[key]; }); desc.enumerable = !!desc.enumerable; desc.configurable = !!desc.configurable; if (`value` in desc || desc.initializer) { desc.writable = true; } desc = decorators.slice().reverse().reduce(function (desc, decorator) { return decorator(target, property, desc) || desc; }, desc); if (context && desc.initializer !== void 0) { desc.value = desc.initializer ? desc.initializer.call(context) : void 0; desc.initializer = undefined; } if (desc.initializer === void 0) { Object[`define` + `Property`](target, property, desc); desc = null; } return desc; }

// Describe stateless, memoisable changes
function memoise(obj, fn, desc) {
    const saved = {};
    console.log(`Memoising`, fn);
    const oldfn = obj[fn];

    obj[fn] = (...args) => {
        var _saved$fn, _saved$fn$strObj;

        const ret = oldfn(...args),
            [objObj, arrArgs] = [...args],
            strObj = JSON.stringify(objObj),
            strArgs = JSON.stringify(arrArgs);

        if (saved === null || saved === void 0 ? void 0 : (_saved$fn = saved[fn]) === null || _saved$fn === void 0 ? void 0 : (_saved$fn$strObj = _saved$fn[strObj]) === null || _saved$fn$strObj === void 0 ? void 0 : _saved$fn$strObj[strArgs]) {
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

const Books = (_obj = {
    push: (books, book) => {
        const newBooks = [...books];
        newBooks.push(book);
        return newBooks;
    }
}, (_applyDecoratedDescriptor(_obj, `push`, [memoise], (_init = Object.getOwnPropertyDescriptor(_obj, `push`), _init = _init ? _init.value : undefined, {
    enumerable: true,
    configurable: true,
    writable: true,
    initializer: function () {
        return _init;
    }
}), _obj)), _obj);
const Person = (_obj2 = {
    setName: (person, name) => {
        const newPerson = _objectWithoutProperties(_extends({}, person), []);

        newPerson.name = name;
        return newPerson;
    },
    setAge: (person, age) => _extends({}, person, {
        age
    }),
    format: person => `${person.name} is ${person.age} and has the following books: ${person.books.join(`, `)}`,
    addBook: (person, book) => _extends({}, person, {
        books: Books.push(person.books || (person.books = []), book)
    })
}, (_applyDecoratedDescriptor(_obj2, `setName`, [memoise], (_init2 = Object.getOwnPropertyDescriptor(_obj2, `setName`), _init2 = _init2 ? _init2.value : undefined, {
    enumerable: true,
    configurable: true,
    writable: true,
    initializer: function () {
        return _init2;
    }
}), _obj2), _applyDecoratedDescriptor(_obj2, `setAge`, [memoise], (_init3 = Object.getOwnPropertyDescriptor(_obj2, `setAge`), _init3 = _init3 ? _init3.value : undefined, {
    enumerable: true,
    configurable: true,
    writable: true,
    initializer: function () {
        return _init3;
    }
}), _obj2), _applyDecoratedDescriptor(_obj2, `format`, [memoise], (_init4 = Object.getOwnPropertyDescriptor(_obj2, `format`), _init4 = _init4 ? _init4.value : undefined, {
    enumerable: true,
    configurable: true,
    writable: true,
    initializer: function () {
        return _init4;
    }
}), _obj2), _applyDecoratedDescriptor(_obj2, `addBook`, [memoise], (_init5 = Object.getOwnPropertyDescriptor(_obj2, `addBook`), _init5 = _init5 ? _init5.value : undefined, {
    enumerable: true,
    configurable: true,
    writable: true,
    initializer: function () {
        return _init5;
    }
}), _obj2)), _obj2);
console.log(Person.format(Person.setAge(Person.addBook(Person.setAge(Person.setAge(Person.setAge(Person.setName({
    name: `Bob`,
    age: 23
}, `Dan`), 26), 26), 26), `The Latin Kingdoms`), 26)));