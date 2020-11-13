var text = require("fs").readFileSync(process.argv[2]).toString();
var sentences = text.match(/([A-Z].+\.)/g), chooseRandom = function (arr) { return arr[Math.floor(Math.random() * arr.length)]; }, pickByProbability = function (map) {
    var rand = Math.random(), total = Array.from(map.values()).reduce(function (a, b) { return a + b; }), toExceed = rand / total;
    var soFar = 0;
    for (var _i = 0, map_1 = map; _i < map_1.length; _i++) {
        var _a = map_1[_i], word_1 = _a[0], times = _a[1];
        soFar += times;
        // maybe
        if ((soFar / total) > toExceed) {
            return word_1;
        }
    }
}, byFreq = new Map(), firsts = sentences.map(function (sentence) { return sentence.split(/\s+/)[0]; }), lasts = sentences.map(function (sentence) {
    var arr = sentence.split(/\s+/);
    return arr[arr.length - 1];
});
sentences.forEach(function (sentence) {
    var words = sentence.split(/\s+/g);
    for (var i = 0; i < words.length - 1; i++) {
        var current = words[i], next = words[i + 1];
        if ("undefined" === typeof next) {
            console.debug("Not setting " + current + " to anything.");
            continue;
        }
        //console.log(current, next);
        if (!byFreq.has(current)) {
            byFreq.set(current, new Map([[next, 1]]));
            continue;
        }
        var sub = byFreq.get(current);
        if (!sub.has(next)) {
            sub.set(next, 1);
            continue;
        }
        sub.set(next, sub.get(next) + 1);
        byFreq.set(current, sub);
    }
});
var finishedSentence = [];
var ended = false, word = chooseRandom(firsts);
while (!ended) {
    if (lasts.includes(word) || 30 < finishedSentence.length) {
        ended = true;
        finishedSentence.push(word);
        break;
    }
    finishedSentence.push(word);
    var newProbMap = byFreq.get(word);
    word = pickByProbability(newProbMap);
}
console.log(finishedSentence.join(" "));
