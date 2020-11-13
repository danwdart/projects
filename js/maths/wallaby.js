module.exports = function (wallaby) {
    return {
        files: [
            `src/**/*js`
        ],

        tests: [
            `test/**/*.spec*js`
        ],

        testFramework: `mocha`
    };
};