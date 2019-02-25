console.log(`Unfart Initialised`);
const doReplaceName = new Map([
    [
        /Donald John Trump/i,
        `Farthole Butthole McGee`
    ],
    [
        /Donald J. Trump/i,
        `Farthole B. McGee`
    ],
    [
        /Donald Trump/i,
        `Did a Fart`
    ],
    [
        /Trump/,
        `Fart`
    ]
]).forEach((v, k) => document.documentElement.innerHTML = document.documentElement.innerHTML.replace(new RegExp(k, 'g'), v));

const doReplaceTweets = "https://twitter.com/realdonaldtrump" === window.location.href ?
    [].forEach.call(document.querySelectorAll('.TweetTextSize'), p => p.innerHTML = "Poo poo poo.") :
    () => {};

const doReplace = () => doReplaceName() && doReplaceTweets();

window.addEventListener('load', doReplace);
doReplace();

console.log(`Unfart Finished`);