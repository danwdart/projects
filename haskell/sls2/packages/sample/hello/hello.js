function main(args, ctx) {
    return {
        body: {
            args,
            ctx
        },
        headers: {
            "content-type": "application/json"
        }
    };
}
