export const streamToString = response =>
    new Promise((res, rej) => {
        let responseString = '';
        response.on('error', rej);
        response.on('data', dataChunk => {
            responseString += dataChunk.toString();
        });
        response.on('end', () => res(responseString));
    });