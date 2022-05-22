export const data = () => "Data";
export const io = () => console.log("Hello from JS!");
export const fn = x => {
    const out = x;
    console.log(out);
    return out;
}
export const add = x => x + 42;