(function() {

	var Ajax = {
			get: function(url, cb) {
				var x = new XMLHttpRequest();
				x.open('GET', url, true);
				x.addEventListener('readystatechange', function() {
					if (4 == x.readyState) {
						if (200 == x.status) {
							cb(x.responseText)
						}
					}
				});
				x.send();
			}
		},
		VM = {
			query: document.querySelector('[name=q]'),
			results: document.querySelector('#results'),
			audio: document.querySelector('audio'),
			timer: null,
			initial: 'Bob',
			url: 'https://api.jamendo.com/v3.0/tracks?audioformat=ogg&client_id=116b585a&namesearch=',
			ajcb: function(data) {
				var obj = JSON.parse(data),
					result = '';
				for (i in obj.results) {
					var res = obj.results[i];
					result += '<tr><td>'+
						'<a href="#" data-audio="'+
						res['audio'] +
						'" onclick="VM.play(this);">' +
						res['name'] +
						'</a></td><td>' +
						res['album_name'] +
						'</td><td>' +
						res['artist_name']+'</td></tr>';
				}
				this.results.innerHTML = result;
			},
			search: function(whatfor) {
				Ajax.get(
					this.url + whatfor,
					this.ajcb.bind(this)
				);
			},
			keyup: function() {
				clearTimeout(this.timer);
				if (2 < this.query.value.length) {
					this.timer = setTimeout(function() {
						this.search(this.query.value);
					}.bind(this), 400);
				}
			},
			play: function(what) {
				this.audio.src = what.getAttribute('data-audio');
				this.audio.play();
			}, 
			init: function() {
				this.query.value = this.initial;
				this.query.addEventListener('keyup', this.keyup.bind(this));
				this.search(this.initial);
			} 
		};

	VM.init();

	window.VM = VM;

})();