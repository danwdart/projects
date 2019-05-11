'use strict';

const $ = document.querySelector.bind(document);

const algorithm = {
    name: "RSA-OAEP",
    modulusLength: 4096,
    publicExponent: new Uint8Array([1, 0, 1]),
    hash: "SHA-256",
};
const encryptionAlgorithm = {
    name: "RSA-OAEP"
};
const extractable = true;
const keyUsages = [
    "encrypt", "decrypt"
];
const privKeyUsages = ["decrypt"];
const pubKeyUsages = ["encrypt"];
const privKeyFormat = "pkcs8";
const pubKeyFormat = "spki";

const dom = {
    text: {
        input: $("#input"),
        output: $("#output"),
        pubkey: $("#pubkey"),
        privkey: $("#privkey")
    },
    button: {
        encrypt: $("#encrypt"),
        decrypt: $("#decrypt"),
        generate: $("#generate"),
        import: $("#import")
    }
};

const bPrefix = 'data:application/octet-stream;base64,';

const binaryBufferToBase64 = binaryBuffer => new Promise((res, rej) => {
    const blob = new Blob([new DataView(binaryBuffer)], {type: 'application/octet-stream'});
    const reader = new FileReader();
    reader.onload = ev => res(ev.target.result.substr(bPrefix.length));
    reader.onerror = err => rej(err);
    reader.readAsDataURL(blob, {type: 'application/octet-stream'});
});

const base64ToBinaryBuffer = async base64 => {
    const response = await fetch(`${bPrefix}${base64}`);
    return await response.arrayBuffer();
};

let state = {
    text: {
        input: null,
        output: null,
        pubkey: null,
        privkey: null
    },
    keyPair: null
};

const setState = newStateFn => {
    state = newStateFn(state);
    Object.entries(dom.text).map(([k]) => changeInput(k)(state.text[k]));
};

const btnFns = {
    encrypt: async () => {
        const encrypted = await binaryBufferToBase64(
            await crypto.subtle.encrypt(
                encryptionAlgorithm,
                state.keyPair.publicKey,
                new TextEncoder('utf8').encode(state.text.input)
            )
        );

        setState(state => ({
            ...state,
            text: {
                ...state.text,
                input: '',
                output: encrypted
            }
        }));
    },
    decrypt: async () => {
        const decrypted = new TextDecoder('utf8').decode(
            await crypto.subtle.decrypt(
                encryptionAlgorithm,
                state.keyPair.privateKey,
                await base64ToBinaryBuffer(state.text.output)
            )
        );

        setState(state => ({
            ...state,
            text: {
                ...state.text,
                input: decrypted,
                output: ''
            }
        }));
    },
    generate: async () => {
        const keyPair = await pGenerate();

        //console.log(
            //await crypto.subtle.exportKey("raw", keyPair.publicKey),
            //await crypto.subtle.exportKey("pkcs8", keyPair.publicKey),
            
            //(await crypto.subtle.exportKey("jwk", keyPair.publicKey)).n
        //);

        //console.log(
            //await crypto.subtle.exportKey("raw", keyPair.privateKey),
            
            //await binaryBufferToBase64(await crypto.subtle.exportKey("spki", keyPair.privateKey)),
            //(await crypto.subtle.exportKey("jwk", keyPair.privateKey))
        //);

        const privkey = (await binaryBufferToBase64(await crypto.subtle.exportKey(privKeyFormat, keyPair.privateKey)));
        const pubkey = (await binaryBufferToBase64(await crypto.subtle.exportKey(pubKeyFormat, keyPair.publicKey)));


        setState(state => ({
            ...state,
            text: {
                ...state.text,
                privkey,
                pubkey
            },
            keyPair
        }));
    },
    import: async () => {
        const keyPair = {
            publicKey: await crypto.subtle.importKey(
                pubKeyFormat,
                await base64ToBinaryBuffer(state.text.pubkey),
                algorithm,
                extractable,
                pubKeyUsages
            ),
            privateKey: await crypto.subtle.importKey(
                privKeyFormat,
                await base64ToBinaryBuffer(state.text.privkey),
                algorithm,
                extractable,
                privKeyUsages
            )
        };

        setState(state => ({
            ...state,
            keyPair
        }));
    }
}

const changeState = name => ev => state.text[name] = ev.currentTarget.value;
const detectState = name => state.text[name] = dom.text[name].value;
const changeInput = name => newVal => dom.text[name].value = newVal;

const pGenerate = () => crypto.subtle.generateKey(algorithm, extractable, keyUsages);

const main = () => {
    Object.entries(dom.text).forEach(([k, v]) => v.addEventListener("change", changeState(k)));
    Object.keys(dom.text).forEach(detectState);
    Object.entries(dom.button).forEach(([k, v]) => v.addEventListener("click", btnFns[k]));
    //window.addEventListener('DOMContentLoaded', () => Object.values(dom.text).forEach(detectState));
};