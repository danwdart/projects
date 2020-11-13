export default keyfn => array => {
    const hash = {};
    return array.filter(item => {
        const key = keyfn(item);

        return hash.hasOwnProperty(key) ?
            false :
            (hash[key] = true);
    });
};