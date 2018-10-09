export const logistic = (i, oldx, oldy) => {
    if (0 === oldy) {
        oldy = 0.5;
    }

    // chaos
    return 3.8 * oldy * (1 - oldy);
};