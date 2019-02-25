module.exports = {
    "env": {
        "es6": true,
        "node": true
    },
    "extends": [
        "plugin:cleanjs/recommended"
    ],
    "parserOptions": {
        "ecmaVersion": 2018,
        "sourceType": "module"
    },
    "plugins": [
        "cleanjs"
    ],
    "rules": {
        "indent": [
            "error",
            4
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
            "single"
        ],
        "semi": [
            "error",
            "always"
        ],
        "no-console": [
            0
        ],
        "cleanjs/no-nil": [
            0
        ]
    }
};