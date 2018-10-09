export const generatorToFunction = gen => {
    const genned = gen();
    return () => genned.next().value;
};