const { spawn } = require('node:child_process');

const main = (args, ctx) => new Promise((res, rej) => {
    const { http, __pw_method, __ow_path, __ow_headers, ...ownArgs } = args;
    try {
        // const ls = spawn('ldd', ["./sls2"]);
        process.env.LD_LIBRARY_PATH = `${process.cwd()}:${process.env.LD_LIBRARY_PATH}`;

        // @TODO: pass as stdin rather than args
        const ls = spawn("./ld-linux-x86-64.so.2", ["--library-path", ".", "./sls2", JSON.stringify(ownArgs)]);

        let stdout = "";
        let stderr = "";

        ls.on("error", err => {
            console.error(err);
        })

        ls.stdout.on('data', data => {
            stdout += data;
        });
        
        ls.stderr.on('data', data => {
            stderr += data;
        });
        
        ls.on('close', code => {
            console.log(`child process exited with code ${code}`);

            res({
                body: JSON.parse(stdout),
                headers: {
                    "content-type": "application/json"
                }
            });
        });
        
    } catch (err) {
        res({
            body: {
                error: err.message
            },
            headers: {
                "content-type": "application/json"
            }
        });
    }
});

module.exports = {
    main  
};

// E.g. TEST=1 node packages/sample/hello/hello.js {\"a\":\"b\"}
if (process.env.TEST) {
    process.chdir(__dirname);
    module.exports.main(JSON.parse(process.argv[2]), {}).then(output => console.log(JSON.stringify({output}, null, 4))).catch(console.error);
    // console.log(main(process.argv));
}
