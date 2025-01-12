module Main (main) where

main ∷ IO ()
main = pure ()

{-

#!/usr/bin/env node

var fs = require('fs'),
    Word = require('./word'),
    argv = process.argv,
    // Number casting is more efficient than parseInt()...
    nPhonemes = Number(argv[2]),
    lang = argv[3],
    phonemes = JSON.parse(fs.readFileSync(__dirname+'/lang/'+(('undefined' == typeof lang)?'en_GB':String(lang))+'.json')),
    strWord;

// ... but still requires some error checking
if ('number' !== typeof nPhonemes || isNaN(nPhonemes)) {
    console.log('Usage: '+argv[1]+' (number of phonemes) [lang e.g. en_GB]');
    return process.exit(1);
}

strWord = Word(nPhonemes, phonemes);

console.log(strWord);

-}
