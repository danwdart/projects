export default comboLength => array => {
    const out = [];

    const numTags = array.length;

    if (comboLength > numTags) {
        return array;
    }

    // only 2 for now
    for (let i = 0; i < numTags; i++) {
        for (let j = 0; j < i; j++) {
            out.push(`${array[i]} ${array[j]}`);
        }
    }

    return out;
}