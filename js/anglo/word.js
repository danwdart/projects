// I am very evil indeed.
Array.prototype.pick = function () {
    return this[Math.floor(Math.random() * this.length)];
}

// invoke with a number to generate
module.exports = function Word(nPhonemes)
{
    // Hardcoded for now. Might do other languages though.
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
        // Choose vowel or consonant
		current = [0,1].pick();

	for (var i = 1; i <= nPhonemes; i++) {
        // Append a random letter
		word += phonemes[current].pick();
        // and flip the bit so we pick the other next time
		current = Number(!current);
	}

	return word;
};
