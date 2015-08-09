!function() {
    var Body = function() {
        function Body() {
            this.title = Fef.obs();
            this.text = Fef.obs();
            this.para = Fef.obs();
        }

        return Body;
    }();

    var Fef =function() {
        function Fef() {
            this._models = [];
        }

        function get(query, start) {
            if (null == start) start = document;
            return start.querySelector(query);
        }

        function getfef(name, start) {
            if (null == start) start = document;
            return get('[data-fef-'+name+']', start)
        }

        function fefval(el, name) {
            return el.data['fef-'+name];
        }

        function forEach(things, anddo) {
            for (var i = 0; i < things.length; i++) {
                anddo(things[i]);
            }
        }

        Fef.prototype.initModel = function(model) {
            var modelName = fefval(model, 'model');
            this._models.push(
                {
                    name: modelName,
                    model: new modelName,
                    dom: model
                }
            );
        }

        Fef.prototype.init = function() {
            var models = getfef('model');
            forEach(models, this.initModel.bind(this));

        };

        return Fef;
    }();

    var fef = new Fef();
    fef.init();
}();