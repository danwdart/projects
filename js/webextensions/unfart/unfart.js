console.log(`Unfart Initialised`);
window.addEventListener('load', () => 
    new Map([
        [
            /Donald John Trump/i,
            `Farthole McGee`
        ],
        [
            /Donald Trump/i,
            `Did a Fart`
        ],
        [
            /Trump/,
            `Fart`
        ]
    ]).forEach((v, k) => document.documentElement.innerHTML = document.documentElement.innerHTML.replace(new RegExp(k, 'g'), v))
);

console.log(`Unfart Finished`);