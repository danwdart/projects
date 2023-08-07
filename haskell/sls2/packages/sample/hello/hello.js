const { spawn } = require('node:child_process');

const main = (args, ctx) => new Promise((res, rej) => {
    const { http, __pw_method, __ow_path, __ow_headers, __ow_method, ...ownArgs } = args;
    try {
        // const ls = spawn('ldd', ["./sls2"]);
        process.env.LD_LIBRARY_PATH = `${process.cwd()}:${process.env.LD_LIBRARY_PATH}`;

        // @TODO: pass as stdin rather than args
        const proc = spawn("./ld-linux-x86-64.so.2", ["--library-path", ".", "./sls2"]);

        let stdout = "";
        let stderr = "";

        proc.on("error", err => {
            console.error(err);
        })

        proc.stdout.on('data', data => {
            stdout += data;
        });
        
        proc.stderr.on('data', data => {
            stderr += data;
        });
        
        proc.on('close', code => {
            // console.log(`child process exited with code ${code}`);

            res({
                body: stdout ? JSON.parse(stdout) : {},
                headers: {
                    "content-type": "application/json"
                }
            });
        });

        // @TODO: https://nodejs.org/api/child_process.html#child_processspawncommand-args-options
        proc.stdin.write(JSON.stringify(ownArgs));
        proc.stdin.end();
        
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
