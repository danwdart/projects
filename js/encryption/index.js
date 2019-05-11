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
const extractable = false;
const keyUsages = [
    "encrypt", "decrypt"
];
const exportFormat = "pkci";

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
        generate: $("#generate")
    }
};

const bPrefix = 'data:application/octet-stream;base64,';

const binaryBufferToBase64 = binaryBuffer => new Promise((res, rej) => {
    console.log('bb2b', {binaryBuffer})
    const blob = new Blob([new DataView(binaryBuffer)], {type: 'application/octet-stream'});
    const reader = new FileReader();
    reader.onload = ev => console.log({r: ev.target.result}) || res(ev.target.result.substr(bPrefix.length));
    reader.onerror = err => rej(err);
    reader.readAsDataURL(blob, {type: 'application/octet-stream'});
});

const base64ToBinaryBuffer = async base64 => {
    console.log('b2bb', {base64});
    const response = await fetch(`${bPrefix}${base64}`);
    const binary = await response.text();
    console.log({base64, response, binary, e: new TextEncoder('utf8').encode(binary)});
    return new TextEncoder('utf8').encode(binary);
};

let state = {
    text: {
        input: null,
        output: null,
        //pubkey: null,
        //privkey: null
    },
    keyPair: null
};

const setState = newStateFn => {
    state = newStateFn(state);
    Object.entries(dom.text).map(([k]) => changeInput(k)(state.text[k]));
};

const btnFns = {
    encrypt: async () => {
        try {
            console.log('Enc', state.text.input);

            const binaryInput = state.text.input;

            const encodedData = new TextEncoder('utf8').encode(binaryInput)

            const encryptedBinaryBuffer = await crypto.subtle.encrypt(
                encryptionAlgorithm,
                state.keyPair.publicKey,
                encodedData
            );

            console.log('Enc1.4', encryptedBinaryBuffer)

            const encrypted = await binaryBufferToBase64(encryptedBinaryBuffer);

            console.log('Enc2', encrypted);

            setState(state => ({
                ...state,
                text: {
                    ...state.text,
                    output: encrypted
                }
            }));

            console.log(state.text.output);
        } catch (err) {
            console.error(err);
        }
    },
    decrypt: async () => {
        try {
            const decrypted = await crypto.subtle.decrypt(
                encryptionAlgorithm,
                state.keyPair.privateKey,
                await base64ToBinaryBuffer(state.text.output)
            );

            setState(state => ({
                ...state,
                text: {
                    ...state.text,
                    output: decrypted
                }
            }));
        } catch (err) {
            console.error(err);
        }
    },
    generate: async () => {
        const keyPair = await pGenerate();

        setState(state => ({
            ...state,
            keyPair
        }));
    }
}

const changeState = name => ev => state.text[name] = ev.currentTarget.value;
const changeInput = name => newVal => dom.text[name].value = newVal;

const pGenerate = () => crypto.subtle.generateKey(algorithm, extractable, keyUsages);

const main = () => {
    Object.entries(dom.text).map(([k, v]) => v.addEventListener("change", changeState(k)));
    Object.entries(dom.button).map(([k, v]) => v.addEventListener("click", btnFns[k]));
};