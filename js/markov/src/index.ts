const text = require(`fs`).readFileSync(process.argv[2]).toString();

const sentences = text.match(/([A-Z].+\.)/g) as string[],
    chooseRandom = (arr: string[]) => arr[Math.floor(Math.random() * arr.length)],
    pickByProbability = (map: Map<string, number>) => {
        const rand = Math.random(),
            total = Array.from(map.values()).reduce((a, b) => a + b) as number,
            toExceed = rand / total;
        let soFar = 0;
        for (let [word, times] of map) {
            soFar += times;
            // maybe
            if ((soFar/total) > toExceed) {
                return word;
            }
        }
        return '';
    },
    byFreq: Map<string, Map<string, number>> = new Map(),
    firsts = sentences.map(
        sentence => sentence.split(/\s+/)[0]
    ),
    lasts = sentences.map(
        sentence => {
            const arr = sentence.split(/\s+/);
            return arr[arr.length - 1];
        }
    );

sentences.forEach(sentence => {
    const words = sentence.split(/\s+/g);
    for (let i = 0; i < words.length - 1; i++) {
        const current = words[i],
            next = words[i + 1];
        
        if (`undefined` === typeof next) {
            console.debug(`Not setting ${current} to anything.`);
            continue;
        }
        //console.log(current, next);
        if (!byFreq.has(current)) {
            byFreq.set(current, new Map([[next, 1]]));
            continue;
        }

        const sub = byFreq.get(current);

        if (sub) {
            if (!sub.has(next)) {
                sub.set(next, 1);
                continue;
            }
            
            const subNext = sub.get(next)
            
            if (subNext) {
                sub.set(next, subNext + 1);
            }

            byFreq.set(current, sub);
        }
    }
});

const finishedSentence = [];
let ended = false,
    word = chooseRandom(firsts);
while (!ended) {
    if (lasts.includes(word) || 30 < finishedSentence.length) {
        ended = true;
        finishedSentence.push(word);  
        break;
    }

    finishedSentence.push(word);  

    let newProbMap = byFreq.get(word);
    if (newProbMap) {
        word = pickByProbability(newProbMap);
    }
}

console.log(finishedSentence.join(` `));