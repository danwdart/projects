const { spawn } = require('node:child_process');

const main = (args, ctx) => new Promise((res, rej) => {
    try {
        const { http, __ow_path, __ow_headers, __ow_method, ...ownArgs } = args;

        // const ls = spawn('ldd', ["./sls2"]);
        process.env.LD_LIBRARY_PATH = `${process.cwd()}:${process.env.LD_LIBRARY_PATH}`;

        // @TODO: pass as stdin rather than args
        const proc = spawn("./ld-linux-x86-64.so.2", ["--library-path", ".", "./sls2"]);

        let stdout = "";
        let stderr = "";

        proc.on("error", err => {
            console.error(err);
            res({
                body: {
                    message: `Error: child process errored`,
                    data: {
                        err,
                        stdout,
                        stderr
                    }
                },
                statusCode: 500,
                headers: {
                    "Content-Type": "application/json"
                }
            });
            return;
        })

        proc.stdout.on('data', data => {
            stdout += data;
        });
        
        proc.stderr.on('data', data => {
            stderr += data;
        });
        
        proc.on('close', code => {
            if (code > 0) {
                res({
                    body: {
                        message: `Error: child process exited with code ${code}`,
                        data: {
                            code,
                            stdout,
                            stderr
                        }
                    },
                    statusCode: 500,
                    headers: {
                        "Content-Type": "application/json"
                    }
                });
                return;
            }

            res(stdout ? JSON.parse(stdout) : {
                body: {
                    message: "Error: no data returned from child process.",
                    stderr
                },
                statusCode: 500,
                headers: {
                    "Content-Type": "application/json"
                }
            });
        });

        // @TODO: https://nodejs.org/api/child_process.html#child_processspawncommand-args-options
        proc.stdin.write(JSON.stringify({
            path: __ow_path,
            headers: __ow_headers,
            method: __ow_method,
            http,
            args: ownArgs,
            ctx
        }));
        proc.stdin.end();
        
    } catch (err) {
        res({
            body: {
                error: err.message
            },
            statusCode: 500,
            headers: {
                "content-type": "application/json"
            }
        });
    }
});

module.exports = {
    main  
};

// E.g. TEST=1 node packages/sls2/hello/hello.js '{"__ow_path":"aaa","__ow_headers":{},"__ow_method":"POST","http":{},"myString":"b","myInt":2,"ctx":{}}'
if (process.env.TEST) {
    process.chdir(__dirname);
    module.exports.main(JSON.parse(process.argv[2]), {}).then(output => console.log(JSON.stringify(output, null, 4))).catch(console.error);
    // console.log(main(process.argv));
}
