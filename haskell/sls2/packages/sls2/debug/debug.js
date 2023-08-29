const { spawn } = require('node:child_process');

const main = (args, ctx) => new Promise((res, rej) => {
    try {
        // const ls = spawn('ldd', ["./sls2"]);
        process.env.LD_LIBRARY_PATH = `${process.cwd()}:${process.env.LD_LIBRARY_PATH}`;

        const ls = spawn("./ld-linux-x86-64.so.2", ["--library-path", ".", "./sls2", "--version"]);

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
                body: {
                    output: {
                        stdout: stdout.split("\n"),
                        stderr,
                        code
                    },
                    args,
                    ctx,
                    cwd: process.cwd(),
                    env: process.env,
                    arch: process.arch
                },
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

if (process.env.TEST) {
    module.exports.main(process.argv).then(output => console.log(JSON.stringify({output}, null, 4))).catch(console.error);
    // console.log(main(process.argv));
}
