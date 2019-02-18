export const triggy = (i, oldx, oldy) => {
    if (0 === oldy) {
        oldy = 0.5;
    }
    
    return Math.tan(oldy);
};