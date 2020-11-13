class Fef {
    constructor() {
        this._models = [];
    }

    #get(query, start) {
        if (null == start) start = document;
        return start.querySelector(query);
    }

    #getfef(name, start) {
        if (null == start) start = document;
        return this.#get('[data-fef-'+name+']', start)
    }

    #fefval(el, name) {
        return el.data['fef-'+name];
    }

    initModel(model) {
        var modelName = this.#fefval(model, 'model');
        this._models.push(
            {
                name: modelName,
                model: new modelName,
                dom: model
            }
        );
    }

    init() {
        var models = this.#getfef('model');
        [].prototype.forEach(models, this.initModel.bind(this));
    };
}

const fef = new Fef();

fef.init();
