Array.prototype.pick = function () {
    return this[Math.floor(Math.random() * this.length)];
}

module.exports = function Word(nLetters)
{
	var phonemes = [
			[
				"a", "aa", "ae", "ai", "au",
				"e", "ea", "ee", "ei", "eu",
				"i", "ia", "ie", "iu",
				"o", "oa", "oe", "oi", "oo", "ou", "ough",
				"u", "ui",
				"y"
			],
			[
				"b", "br", "c", "ck", "cr", "cs", "ct", "cy",
				"d", "dr", "f", "fh", "g", "gh", "gth",
				"h", "j", "k", "l", "ll", "m", "mm",
				"n", "nn", "p", "ph", "qu", "r",
				"s", "sc", "sh", "st", "str", "t", "tch", "tr",
				"v", "w", "wh", "x", "y", "z"
			]
		],
		word = '',
		current = [0,1].pick();

	for (var i = 1; i <= nLetters; i++) {
		word += phonemes[current].pick();
		current = Number(!current);
	}

	return word;
};